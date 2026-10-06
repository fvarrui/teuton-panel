# frozen_string_literal: true

require "fileutils"
require "json"
require "yaml"
require_relative "version"

module Teuton::Panel
  ##
  # Archive a class session (registrations, results, runs) and read old ones
  class Sessions
    ##
    # @param workspace (Workspace)
    def initialize(workspace)
      @workspace = workspace
    end

    ##
    # Move registrations, results and runs into a dated folder
    # @param label (String) Optional name typed by the teacher
    # @return String session id
    def archive(label = "")
      id = Time.now.strftime("%Y%m%d-%H%M%S")
      target = File.join(@workspace.archive_dir, id)
      FileUtils.mkdir_p(target)
      move_registrations(File.join(target, "config.d"))
      move(@workspace.results_path, File.join(target, "results.json"))
      move(@workspace.runs_dir, File.join(target, "runs"))
      info = {"id" => id, "label" => label.to_s.strip, "test" => @workspace.project.name, "archived_at" => Time.now.to_s}
      File.write(File.join(target, "session.json"), JSON.pretty_generate(info))
      id
    end

    ##
    # Archived sessions, newest first
    def list
      return [] unless Dir.exist?(@workspace.archive_dir)

      ids = Dir.children(@workspace.archive_dir).sort.reverse
      ids.map { info(_1) }.compact
    end

    def info(id)
      filepath = File.join(dirpath(id), "session.json")
      return nil unless File.exist?(filepath)

      JSON.parse(File.read(filepath))
    end

    def dirpath(id)
      File.join(@workspace.archive_dir, File.basename(id.to_s))
    end

    def to_s
      "Sessions: #{@workspace.archive_dir}"
    end

    private

    def move_registrations(target)
      dirpath = @workspace.project.include_dir
      return if dirpath.nil? || !Dir.exist?(dirpath)

      FileUtils.mkdir_p(target)
      Dir.glob(File.join(dirpath, "*.{yaml,yml,json}")).each { FileUtils.mv(_1, target) }
    end

    def move(source, target)
      return unless File.exist?(source)

      FileUtils.mv(source, target)
    end
  end
end
