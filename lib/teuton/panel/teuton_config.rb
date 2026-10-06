# frozen_string_literal: true

require "fileutils"
require "yaml"
require_relative "version"

module Teuton::Panel
  ##
  # Read and minimally edit a Teuton config.yaml.
  # Writes are text edits so the teacher's comments survive (ADR-002: never
  # put hash values in global, Teuton 3.0.0 crashes on them).
  module TeutonConfig
    INCLUDE_DIR = "config.d"

    ##
    # Parsed content with string keys ({} when missing or invalid)
    # @param configpath (String)
    def self.read(configpath)
      return {} unless File.exist?(configpath)

      data = YAML.safe_load_file(configpath, permitted_classes: [Symbol], aliases: true) || {}
      stringify(data)
    rescue => e
      warn "[WARN] TeutonConfig.read: #{e} <#{configpath}>"
      {}
    end

    ##
    # Absolute include dir, or nil when tt_include is not set
    # @param configpath (String)
    def self.include_dir(configpath)
      global = read(configpath)["global"] || {}
      dirname = global["tt_include"]
      return nil if dirname.nil? || dirname.to_s.empty?

      File.expand_path(dirname.to_s, File.dirname(configpath))
    end

    ##
    # Cases written by hand in the cases: list
    # @param configpath (String)
    def self.cases(configpath)
      list = read(configpath)["cases"]
      list.is_a?(Array) ? list.select { _1.is_a?(Hash) } : []
    end

    ##
    # Make sure config.yaml exists and sets tt_include, editing it as text
    # @param configpath (String)
    # @return String Absolute include dir
    def self.ensure_include(configpath)
      if File.exist?(configpath)
        insert_include(configpath) if include_dir(configpath).nil?
      else
        File.write(configpath, default_content)
      end
      dirpath = include_dir(configpath)
      FileUtils.mkdir_p(dirpath)
      dirpath
    end

    def self.default_content
      <<~YAML
        # Teuton config created by teuton-panel.
        # tt_include: directory with one YAML file per registered student.
        # Registration fields are in teuton-panel-params.yaml (same directory).
        global:
          tt_include: #{INCLUDE_DIR}
        cases: []
      YAML
    end

    def self.insert_include(configpath)
      lines = File.read(configpath).lines
      index = lines.index { _1.start_with?("global:") }
      if index.nil?
        lines.unshift("global:\n  tt_include: #{INCLUDE_DIR}\n")
      else
        lines[index] = "global:\n" if lines[index].match?(/\Aglobal:\s*(\{\s*\}|~|null)?\s*(#.*)?\z/)
        indent = lines[index + 1].to_s[/\A */]
        indent = "  " if indent.nil? || indent.empty?
        lines.insert(index + 1, "#{indent}tt_include: #{INCLUDE_DIR}\n")
      end
      File.write(configpath, lines.join)
    end

    def self.stringify(value)
      if value.is_a?(Hash)
        value.to_h { |k, v| [k.to_s, stringify(v)] }
      elsif value.is_a?(Array)
        value.map { stringify(_1) }
      else
        value
      end
    end

    private_class_method :insert_include, :stringify
  end
end
