# frozen_string_literal: true

require "yaml"
require_relative "version"

module Teuton::Panel
  ##
  # Registration fields in teuton-panel-params.yaml (next to config.yaml):
  # field name => ASK | AS NAME | AS EMAIL | AUTO IP | fixed value
  module Params
    FILENAME = "teuton-panel-params.yaml"
    MODES = ["ASK", "AS NAME", "AS EMAIL", "AUTO IP"]
    ASKED = ["ASK", "AS NAME", "AS EMAIL"]

    def self.filepath(project)
      File.join(project.dirpath, FILENAME)
    end

    def self.exists?(project)
      File.exist?(filepath(project))
    end

    ##
    # @param project (Project)
    # @return Hash field => mode (string keys, insertion order)
    def self.load(project)
      return {} unless exists?(project)

      data = YAML.safe_load_file(filepath(project)) || {}
      data.to_h { |k, v| [k.to_s, v.to_s] }
    rescue => e
      warn "[WARN] Params.load: #{e} <#{filepath(project)}>"
      {}
    end

    ##
    # @param project (Project)
    # @param params (Hash) field => mode
    def self.save(project, params)
      lines = ["# Registration fields for teuton-panel and how each one is filled:\n"]
      lines << "# ASK (free text), AS NAME, AS EMAIL, AUTO IP (request IP) or a fixed value.\n"
      params.each { |field, mode| lines << "#{field}: #{mode.to_s.inspect}\n" }
      File.write(filepath(project), lines.join)
    end

    def self.asked?(mode)
      ASKED.include?(mode)
    end

    def self.fixed?(mode)
      !MODES.include?(mode)
    end

    ##
    # Propose params from `teuton config` output (keys with TOCHANGE values)
    # @param content (String) YAML printed by teuton config
    def self.propose(content)
      data = YAML.safe_load(content.to_s, permitted_classes: [Symbol]) || {}
      first = (data["cases"] || data[:cases] || []).first || {}
      keys = first.keys.map(&:to_s).reject { _1 == "tt_source_ip" || _1 == "tt_source_file" }
      keys = ["tt_members"] + keys unless keys.include?("tt_members")
      keys.to_h { [_1, propose_mode(_1)] }
    rescue => e
      warn "[WARN] Params.propose: #{e}"
      {"tt_members" => "AS NAME"}
    end

    def self.propose_mode(key)
      return "AS NAME" if key == "tt_members"
      return "AS EMAIL" if key == "tt_moodle_id"
      return "AUTO IP" if key.end_with?("_ip")

      "ASK"
    end
  end
end
