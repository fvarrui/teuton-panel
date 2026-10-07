# frozen_string_literal: true

require_relative "version"
require_relative "teuton_config"

module Teuton::Panel
  ##
  # A Teuton test: a directory with start.rb and (usually) config.yaml
  class Project
    attr_reader :dirpath

    def initialize(dirpath)
      @dirpath = File.expand_path(dirpath)
    end

    def name
      File.basename(@dirpath)
    end

    ##
    # Path relative to basedir, used as the test id in the panel config
    # @param basedir (String)
    def relpath(basedir)
      base = File.expand_path(basedir)
      return name unless @dirpath.start_with?(base)

      rel = @dirpath.delete_prefix(base).delete_prefix("/")
      rel.empty? ? name : rel # The base dir is the test itself
    end

    def startpath
      File.join(@dirpath, "start.rb")
    end

    def configpath
      File.join(@dirpath, "config.yaml")
    end

    def config?
      File.exist?(configpath)
    end

    ##
    # Absolute tt_include dir, or nil
    def include_dir
      TeutonConfig.include_dir(configpath)
    end

    ##
    # Cases written in config.yaml cases:
    def config_cases
      TeutonConfig.cases(configpath)
    end

    def to_s
      "Project: #{@dirpath}"
    end
  end

  module Projects
    ##
    # Find Teuton tests (directories with a start.rb) under basedir
    # @param basedir (String)
    # @return Array of Project
    def self.all(basedir)
      basedir = File.expand_path(basedir) # Also turns C:\dir into C:/dir for Dir.glob
      files = Dir.glob(File.join(basedir, "**", "start.rb")).sort
      files.reject! { _1.include?("/var/") || _1.include?("/.teuton-panel/") }
      files.map { Project.new(File.dirname(_1)) }
    end
  end
end
