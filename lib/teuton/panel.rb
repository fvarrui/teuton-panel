# frozen_string_literal: true

require_relative "panel/version"
require_relative "panel/app"
require_relative "panel/config"
require_relative "panel/history"
require_relative "panel/lang"
require_relative "panel/network"
require_relative "panel/params"
require_relative "panel/project"
require_relative "panel/readme"
require_relative "panel/registration"
require_relative "panel/results_store"
require_relative "panel/run_queue"
require_relative "panel/runner"
require_relative "panel/scheduler"
require_relative "panel/sessions"
require_relative "panel/students"
require_relative "panel/teuton_config"
require_relative "panel/workspace"

module Teuton::Panel
  ##
  # Start the panel from the base directory
  # @param basedir (String) Directory with Teuton tests
  def self.up(basedir)
    $stdout.sync = true
    check_teuton
    projects = Projects.all(basedir)
    if projects.empty?
      warn "[ERROR] Teuton::Panel.up: No Teuton tests found! <#{basedir}>"
      warn "[ERROR] Create one with 'teuton new DIRECTORY' and try again."
      exit 1
    end
    config = Config.new(basedir)
    select_test(config, projects)
    queue = RunQueue.new(config[:runs][:max_parallel])

    App.set(:panel_projects, projects)
    App.set(:panel_config, config)
    App.set(:panel_queue, queue)
    App.set(:panel_scheduler, Scheduler.new(queue))
    App.set(:bind, config[:server][:bind])
    App.set(:port, config[:server][:port])
    at_exit { queue.kill_all }
    show_banner(config)
    App.run!
  end

  ##
  # Student URLs, one per LAN interface
  # @param config (Config)
  def self.student_urls(config)
    port = config[:server][:port]
    Network.local_ips.map { "http://#{_1}:#{port}/students" }
  end

  private_class_method def self.check_teuton
    version = Runner.version
    return if !version.nil? && version.start_with?("3.")

    warn "[ERROR] Teuton::Panel.up: teuton 3.x is required (found: #{version || "none"})"
    warn "[ERROR] Install it with 'gem install teuton -v \"~> 3.0\"'"
    exit 1
  end

  ##
  # Forget an active test that no longer exists and auto-select a single test
  # @param config (Config)
  # @param projects (Array) Project
  def self.select_test(config, projects)
    unless config[:test].nil? || projects.any? { _1.relpath(config.basedir) == config[:test] }
      warn "[WARN] Teuton::Panel.select_test: active test not found <#{config[:test]}>"
      config.update(test: nil)
    end
    return unless config[:test].nil? && projects.size == 1

    test = projects.first
    TeutonConfig.ensure_include(test.configpath)
    Params.save(test, Params.propose(Runner.capture("config", test))) unless Params.exists?(test)
    config.update(test: test.relpath(config.basedir))
  end

  private_class_method def self.show_banner(config)
    line = "-" * 60
    puts line
    puts "#{APPNAME} #{VERSION}"
    puts "Base dir    : #{config.basedir}"
    puts "Active test : #{config[:test] || "(choose one in the teacher area)"}"
    puts "Teacher     : http://localhost:#{config[:server][:port]}/teacher"
    student_urls(config).each do |url|
      puts "Students    : #{url}"
      puts "  curl help : curl #{url}.txt"
    end
    puts line
  end
end
