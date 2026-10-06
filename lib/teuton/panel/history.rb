# frozen_string_literal: true

require "json"
require_relative "version"

module Teuton::Panel
  ##
  # Past runs of a session, read from each run's summary.json
  module History
    ##
    # Summaries of every finished run, newest first
    # @param runs_dir (String)
    def self.runs(runs_dir)
      return [] unless Dir.exist?(runs_dir)

      ids = Dir.children(runs_dir).sort.reverse
      ids.map { summary(File.join(runs_dir, _1)) }.compact
    end

    ##
    # Grades of one student across runs, newest first
    # @param runs_dir (String)
    # @param key (String) tt_panel_key
    def self.for(runs_dir, key)
      runs(runs_dir).map do |run|
        result = run["cases"].find { _1["key"] == key }
        next if result.nil?

        {"run_id" => run["id"], "kind" => run["kind"], "finished_at" => run["finished_at"], "grade" => result["grade"]}
      end.compact
    end

    ##
    # Average grade of a run, or nil
    def self.average(run)
      return nil if run["cases"].empty?

      (run["cases"].sum { _1["grade"].to_f } / run["cases"].size).round(1)
    end

    def self.summary(rundir)
      filepath = File.join(rundir, "summary.json")
      return nil unless File.exist?(filepath)

      JSON.parse(File.read(filepath))
    rescue => e
      warn "[WARN] History.summary: #{e} <#{filepath}>"
      nil
    end
  end
end
