# frozen_string_literal: true

require "fileutils"
require "json"
require_relative "version"

module Teuton::Panel
  ##
  # Latest result of each student (by tt_panel_key), whichever run produced
  # it. Persisted as JSON so it survives restarts.
  class ResultsStore
    LOCK = Mutex.new

    attr_reader :filepath

    def initialize(filepath)
      @filepath = filepath
      @data = load
    end

    ##
    # Merge the cases of a finished run
    # @param summary (Hash) Runner#call result
    def update(summary)
      LOCK.synchronize do
        summary["cases"].each do |result|
          next if result["key"].empty?

          @data["results"][result["key"]] = result.merge("run_id" => summary["id"])
        end
        @data["last_run"] = summary.except("cases")
        save
      end
    end

    def get(key)
      @data["results"][key]
    end

    ##
    # Every stored result, sorted by grade (best first)
    def all
      @data["results"].values.sort_by { [-_1["grade"].to_f, _1["members"].to_s] }
    end

    def last_run
      @data["last_run"]
    end

    def clear
      LOCK.synchronize do
        @data = empty
        save
      end
    end

    ##
    # Moodle import file (same columns as Teuton's moodle.csv)
    def moodle_csv
      lines = ["MoodleID, TeutonGrade, TeutonFeedback"]
      all.each do |result|
        moodle_id = result["moodle_id"].to_s
        next if moodle_id.empty? || moodle_id == "NODATA"

        moodle_id.split(",").each do |id|
          lines << "#{id.strip},#{result["grade"]},\"Run: #{result["run_id"]}\""
        end
      end
      lines.join("\n") + "\n"
    end

    def to_s
      "ResultsStore: #{@filepath}"
    end

    private

    def empty
      {"results" => {}, "last_run" => nil}
    end

    def load
      return empty unless File.exist?(@filepath)

      data = JSON.parse(File.read(@filepath))
      data["results"] = data["results"] || {}
      data
    rescue => e
      warn "[WARN] ResultsStore.load: #{e} <#{@filepath}>"
      empty
    end

    def save
      FileUtils.mkdir_p(File.dirname(@filepath))
      tmppath = "#{@filepath}.tmp"
      File.write(tmppath, JSON.pretty_generate(@data))
      File.rename(tmppath, @filepath)
    end
  end
end
