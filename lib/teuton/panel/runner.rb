# frozen_string_literal: true

require "json"
require "open3"
require "rbconfig"
require "yaml"
require_relative "version"
require_relative "students"
require_relative "teuton_config"

module Teuton::Panel
  ##
  # Run the teuton CLI as a subprocess (ADR-002) and read its JSON reports
  class Runner
    MAX_SECONDS = 900 # Kill a run that takes longer than this

    ##
    # Command prefix to call teuton: [ruby, path/to/teuton]
    def self.command
      [RbConfig.ruby, Gem.bin_path("teuton", "teuton")]
    rescue Gem::Exception
      ["teuton"]
    end

    ##
    # Installed teuton version, or nil
    def self.version
      output, _status = Open3.capture2e(*command, "version")
      output[/version (\d+\.\d+\.\d+)/, 1]
    rescue => e
      warn "[WARN] Runner.version: #{e}"
      nil
    end

    ##
    # stdout of teuton readme/config/check for a test
    # @param action (String) readme, config or check
    # @param project (Project)
    # @param args (Array) Extra CLI arguments
    def self.capture(action, project, args = [])
      output, _status = Open3.capture2e(*command, action, "--no-color", *args, project.dirpath, chdir: project.dirpath)
      output
    end

    ##
    # Cases of a test as hashes with tt_panel_key, ready for a temp config
    # @param project (Project)
    # @param keys (Array|nil) Only these keys (nil = every enabled case)
    def self.cases(project, keys = nil)
      list = []
      project.config_cases.each_with_index do |data, index|
        list << data.merge("tt_panel_key" => "cfg-#{index + 1}")
      end
      Students.new(project.include_dir).all.each do |student|
        next if student[:disabled]

        key = student[:code] || "file-#{File.basename(student[:filepath], ".*")}"
        list << student[:data].merge("tt_panel_key" => key).except("tt_panel_disabled")
      end
      list.select! { keys.include?(_1["tt_panel_key"]) } unless keys.nil?
      list
    end

    attr_reader :pid

    ##
    # @param workspace (Workspace)
    def initialize(workspace)
      @workspace = workspace
      @project = workspace.project
      @pid = nil # Running teuton process
    end

    ##
    # Run teuton on some cases in a new run directory
    # @param kind (String) full, selection or student
    # @param keys (Array|nil) tt_panel_key values (nil = all)
    # @return Hash run summary
    def call(kind, keys = nil)
      id = @workspace.new_run(kind)
      rundir = @workspace.run_dir(id)
      cases = Runner.cases(@project, keys)
      configpath = write_config(rundir, cases)
      summary = {"id" => id, "kind" => kind, "test" => @project.name, "started_at" => Time.now.to_s}
      summary["keys"] = cases.map { _1["tt_panel_key"] }
      summary["exitcode"] = cases.empty? ? 0 : execute(rundir, configpath)
      summary["finished_at"] = Time.now.to_s
      summary["cases"] = cases.empty? ? [] : read_reports(rundir)
      summary["ok"] = !cases.empty? && summary["cases"].size == cases.size
      File.write(File.join(rundir, "summary.json"), JSON.pretty_generate(summary))
      summary
    end

    def kill
      return if @pid.nil?

      Process.kill("KILL", @pid)
    rescue Errno::ESRCH, Errno::EINVAL
      nil
    end

    def to_s
      "Runner: #{@project.name}"
    end

    private

    def write_config(rundir, cases)
      global = TeutonConfig.read(@project.configpath)["global"] || {}
      global = global.reject { |k, v| k == "tt_include" || v.is_a?(Hash) } # Hashes crash Teuton 3.0.0
      global["tt_testname"] = @project.name
      configpath = File.join(rundir, "config.yaml")
      File.write(configpath, {"global" => global, "cases" => cases}.to_yaml)
      configpath
    end

    def execute(rundir, configpath)
      logpath = File.join(rundir, "output.log")
      args = ["run", "--no-color", "--quiet", "--export=json", "--cpath=#{configpath}", @project.dirpath]
      @pid = Process.spawn(*Runner.command, *args, chdir: rundir, out: logpath, err: [:child, :out])
      status = wait_or_kill
      @pid = nil
      status.nil? ? -1 : status.exitstatus.to_i
    end

    def wait_or_kill
      deadline = Time.now + MAX_SECONDS
      loop do
        _pid, status = Process.wait2(@pid, Process::WNOHANG)
        return status unless status.nil?

        if Time.now > deadline
          kill
          Process.wait2(@pid)
          return nil
        end
        sleep 0.2
      end
    end

    def read_reports(rundir)
      vardir = File.join(rundir, "var", @project.name)
      resume = read_json(File.join(vardir, "resume.json"))
      return [] if resume.nil?

      status = (resume["cases"] || []).to_h { [_1["id"], _1] }
      Dir.glob(File.join(vardir, "case-*.json")).sort.map do |filepath|
        report = read_json(filepath)
        report.nil? ? nil : case_result(report, status)
      end.compact
    end

    def case_result(report, status)
      config = report["config"] || {}
      results = report["results"] || {}
      line = status[results["case_id"]] || {}
      result = {}
      result["key"] = config["tt_panel_key"].to_s
      result["code"] = config["tt_panel_code"]
      result["members"] = config["tt_members"].to_s
      result["moodle_id"] = config["tt_moodle_id"]
      result["grade"] = results["grade"].to_f
      result["unique_fault"] = results["unique_fault"].to_i
      result["conn_status"] = line["conn_status"] || {}
      result["finished_at"] = results["finish_time"]
      result["targets"] = targets(report["groups"] || [])
      result
    end

    def targets(groups)
      groups.flat_map do |group|
        (group["targets"] || []).map do |target|
          item = {"group" => group["title"]}
          %w[target_id description check weight command expected output].each { item[_1] = target[_1] }
          item
        end
      end
    end

    def read_json(filepath)
      return nil unless File.exist?(filepath)

      JSON.parse(File.read(filepath))
    rescue => e
      warn "[WARN] Runner.read_json: #{e} <#{filepath}>"
      nil
    end
  end
end
