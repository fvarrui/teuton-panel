# frozen_string_literal: true

require "fileutils"
require "yaml"
require_relative "version"

module Teuton::Panel
  class Config
    attr_reader :data

    def initialize(basedir)
      @basedir = basedir
      @data = load
    end

    def [](key)
      @data[key]
    end

    private

    def load
      filepath = File.join(@basedir, CONFIGFILE)
      create(filepath) unless File.exist?(filepath)
      YAML.load_file(filepath)
    end

    def create(target)
      source = File.join(__dir__, "files", CONFIGFILE)
      FileUtils.cp(source, target)
      puts "* Create file       => #{target}"
    end
  end
end
