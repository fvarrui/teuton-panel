# frozen_string_literal: true

require "fileutils"
require "yaml"
require_relative "version"

module Teuton::Panel
  ##
  # Panel settings stored in teuton-panel.yaml (symbol keys)
  class Config
    DEFAULTS = {
      server: {bind: "0.0.0.0", port: 4567, addresses: []}, # addresses: shown to students (empty = detected)
      language: "es", # Fallback GUI language
      teacher: {allow: []}, # Extra teacher IPs besides localhost
      test: nil, # Active test (path relative to basedir)
      run: {every: 60, times: 1, delay: 3},
      runs: {max_parallel: 4},
      student: {
        register: true,
        list: true,
        run: true,
        results: true,
        feedback: false,
        history: true,
        status: true,
        readme: true,
        formats: %w[html txt json],
        run_interval: 30
      },
      datadir: ".teuton-panel"
    }

    attr_reader :basedir
    attr_reader :data
    attr_reader :filepath

    def initialize(basedir)
      @basedir = File.expand_path(basedir)
      @filepath = File.join(@basedir, CONFIGFILE)
      @data = load
    end

    def [](key)
      @data[key]
    end

    ##
    # Merge values into the settings and save the file
    # @param values (Hash) Partial settings with symbol keys
    def update(values)
      @data = deep_merge(@data, values)
      save
    end

    def save
      File.write(@filepath, @data.to_yaml)
    end

    ##
    # Absolute path inside the data dir
    # @param parts (Array) Path parts
    def datapath(*parts)
      File.join(@basedir, @data[:datadir], *parts)
    end

    def to_s
      "Config: #{@filepath}"
    end

    private

    def load
      unless File.exist?(@filepath)
        File.write(@filepath, DEFAULTS.to_yaml)
        puts "* Create file       => #{@filepath}"
      end
      begin
        content = YAML.load_file(@filepath, permitted_classes: [Symbol]) || {}
      rescue => e
        warn "[ERROR] Config.load: #{e}"
        warn "[ERROR] Revise file content! <#{@filepath}>"
        exit 1
      end
      deep_merge(DEFAULTS, content)
    end

    def deep_merge(base, other)
      base.merge(other) do |_key, old, new|
        if old.is_a?(Hash) && new.is_a?(Hash)
          deep_merge(old, new)
        else
          new
        end
      end
    end
  end
end
