# frozen_string_literal: true

require "fileutils"
require "securerandom"
require "yaml"
require_relative "version"

module Teuton::Panel
  ##
  # Registered students of a test: one YAML file per student in the
  # tt_include dir (config.d/<code>.yaml), string keys, flat hash.
  class Students
    ALPHABET = "ABCDEFGHJKMNPQRSTUVWXYZ23456789" # No 0/O/1/I/L
    CODE_PATTERN = /\A[A-HJKMNP-Z2-9]{4,6}\z/
    CODE_SIZE = 4
    LOCK = Mutex.new

    attr_reader :dirpath

    ##
    # @param dirpath (String) Absolute tt_include dir
    def initialize(dirpath)
      @dirpath = dirpath
    end

    def self.code?(text)
      text.to_s.match?(CODE_PATTERN)
    end

    ##
    # Every case file in the include dir
    # @return Array of Hash {code:, filepath:, data:, disabled:, time:}
    def all
      return [] if @dirpath.nil? || !Dir.exist?(@dirpath)

      files = Dir.glob(File.join(@dirpath, "**", "*.{yaml,yml}")).sort
      files.map { read(_1) }.compact.sort_by { _1[:time] }
    end

    def find(code)
      return nil unless Students.code?(code)

      all.find { _1[:code] == code }
    end

    ##
    # Create a new student file with a fresh code
    # @param data (Hash) Case values (string keys)
    # @param ip (String) Source IP
    # @return String code
    def create(data, ip)
      LOCK.synchronize do
        FileUtils.mkdir_p(@dirpath)
        code = new_code
        values = data.merge("tt_panel_code" => code, "tt_source_ip" => ip)
        write(File.join(@dirpath, "#{code}.yaml"), values)
        code
      end
    end

    ##
    # Merge values into a student's file
    # @param code (String)
    # @param values (Hash) string keys; a nil value removes the key
    def update(code, values)
      LOCK.synchronize do
        student = find(code)
        return false if student.nil?

        data = student[:data].merge(values)
        data.reject! { |_k, v| v.nil? }
        data["tt_panel_code"] = code
        write(student[:filepath], data)
        true
      end
    end

    def delete(code)
      LOCK.synchronize do
        student = find(code)
        return false if student.nil?

        File.delete(student[:filepath])
        true
      end
    end

    def disable(code, value)
      flag = value ? true : nil
      update(code, {"tt_panel_disabled" => flag})
    end

    ##
    # Give a code to a hand-written file in the include dir
    # @param filepath (String)
    def assign_code(filepath)
      LOCK.synchronize do
        student = read(filepath)
        return nil if student.nil? || !student[:code].nil?

        code = new_code
        write(File.join(@dirpath, "#{code}.yaml"), student[:data].merge("tt_panel_code" => code))
        File.delete(filepath)
        code
      end
    end

    def to_s
      "Students: #{@dirpath}"
    end

    private

    def read(filepath)
      data = YAML.safe_load_file(filepath, permitted_classes: [Symbol]) || {}
      return nil unless data.is_a?(Hash)

      data = data.to_h { |k, v| [k.to_s, v] }
      student = {}
      student[:filepath] = filepath
      student[:data] = data
      student[:code] = Students.code?(data["tt_panel_code"]) ? data["tt_panel_code"] : nil
      student[:disabled] = data["tt_panel_disabled"] == true
      student[:time] = File.mtime(filepath)
      student
    rescue => e
      warn "[WARN] Students.read: #{e} <#{filepath}>"
      nil
    end

    def write(filepath, data)
      File.write(filepath, data.to_yaml)
    end

    def new_code
      used = all.map { _1[:code] }
      loop do
        code = Array.new(CODE_SIZE) { ALPHABET[SecureRandom.random_number(ALPHABET.size)] }.join
        return code unless used.include?(code)
      end
    end
  end
end
