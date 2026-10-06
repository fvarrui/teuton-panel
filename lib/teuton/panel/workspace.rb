# frozen_string_literal: true

require "fileutils"
require_relative "version"

module Teuton::Panel
  ##
  # Paths of one test inside the panel data dir:
  # <datadir>/tests/<slug>/{runs/,results.json} and <datadir>/archive/<slug>/
  class Workspace
    attr_reader :project

    ##
    # @param config (Config)
    # @param project (Project)
    def initialize(config, project)
      @config = config
      @project = project
    end

    def slug
      @project.relpath(@config.basedir).tr("/\\", "__")
    end

    def dirpath
      @config.datapath("tests", slug)
    end

    def runs_dir
      File.join(dirpath, "runs")
    end

    def results_path
      File.join(dirpath, "results.json")
    end

    def archive_dir
      @config.datapath("archive", slug)
    end

    ##
    # Create a new run directory
    # @param kind (String) full, selection or student
    # @return String run id
    def new_run(kind)
      time = Time.now
      id = "#{time.strftime("%Y%m%d-%H%M%S")}-#{format("%03d", time.usec / 1000)}-#{kind}"
      FileUtils.mkdir_p(File.join(runs_dir, id))
      id
    end

    def run_dir(id)
      File.join(runs_dir, id)
    end

    ##
    # Run ids of the session, oldest first
    def run_ids
      return [] unless Dir.exist?(runs_dir)

      Dir.children(runs_dir).select { File.directory?(File.join(runs_dir, _1)) }.sort
    end

    def to_s
      "Workspace: #{dirpath}"
    end
  end
end
