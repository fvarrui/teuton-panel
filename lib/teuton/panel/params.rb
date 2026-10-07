# frozen_string_literal: true

require "yaml"
require_relative "version"

module Teuton::Panel
  ##
  # Registration fields in teuton-panel-params.yaml (next to config.yaml):
  # field name => ASK | AS NAME | AS EMAIL | AUTO IP | fixed value, or the
  # extended form field => {mode: ..., label: ..., help: ...}
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
      read(project).to_h { |k, v| [k.to_s, v.is_a?(Hash) ? v["mode"].to_s : v.to_s] }
    end

    ##
    # Label and help the teacher wrote for each field
    # @param project (Project)
    # @return Hash field => {"label" => String, "help" => String}
    def self.details(project)
      read(project).to_h do |k, v|
        info = v.is_a?(Hash) ? v : {}
        [k.to_s, {"label" => info["label"].to_s, "help" => info["help"].to_s}]
      end
    end

    ##
    # @param project (Project)
    # @param params (Hash) field => mode
    # @param details (Hash) field => {"label", "help"}; fields without them use the short form
    def self.save(project, params, details = {})
      lines = ["# Registration fields for teuton-panel and how each one is filled:\n"]
      lines << "# ASK (free text), AS NAME, AS EMAIL, AUTO IP (request IP) or a fixed value.\n"
      lines << "# Optional label and help for students: field: {mode: ASK, label: \"...\", help: \"...\"}\n"
      params.each do |field, mode|
        info = details[field] || {}
        label = info["label"].to_s
        help = info["help"].to_s
        lines << if label.empty? && help.empty?
          "#{field}: #{mode.to_s.inspect}\n"
        else
          "#{field}: {mode: #{mode.to_s.inspect}, label: #{label.inspect}, help: #{help.inspect}}\n"
        end
      end
      File.write(filepath(project), lines.join)
    end

    def self.read(project)
      return {} unless exists?(project)

      YAML.safe_load_file(filepath(project)) || {}
    rescue => e
      warn "[WARN] Params.load: #{e} <#{filepath(project)}>"
      {}
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
