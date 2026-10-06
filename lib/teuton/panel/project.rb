# frozen_string_literal: true

require_relative "version"

module Teuton::Panel
  class Project
    attr_reader :dirpath

    def initialize(dirpath)
      @dirpath = dirpath
    end

    def name
      File.basename(@dirpath)
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
      files = Dir.glob(File.join(basedir, "**", "start.rb")).sort
      files.map { Project.new(File.dirname(_1)) }
    end
  end
end
