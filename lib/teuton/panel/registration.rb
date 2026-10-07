# frozen_string_literal: true

require_relative "version"
require_relative "network"
require_relative "params"

module Teuton::Panel
  ##
  # Build and validate a student's case values from request params
  class Registration
    EMAIL = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/
    SAFE = %r{\A[\p{L}\p{N} ._@:/-]*\z} # Typed values reach Teuton's commands
    MAX_SIZE = 100

    ##
    # Error key for a typed value, or nil when it is acceptable
    # @param field (String)
    # @param value (String)
    def self.value_error(field, value)
      return "length" if value.size > MAX_SIZE
      return nil if field.include?("password") # Passwords go to SSH, not to commands
      return "chars" unless value.match?(SAFE)

      nil
    end

    attr_reader :data
    attr_reader :errors

    ##
    # @param params (Hash) field => mode (Params.load)
    # @param input (Hash) Request params (string keys)
    # @param ip (String) Request IP
    # @param current (Hash) Existing values when updating (string keys)
    def initialize(params, input, ip, current = {})
      @params = params
      @input = input
      @ip = Network.normalize(ip)
      @current = current
      @data = {}
      @errors = [] # Array of [field, error_key]
    end

    def call
      @params.each { |field, mode| fill(field, mode) }
      self
    end

    def ok?
      @errors.empty?
    end

    ##
    # Fields the student must type, in order
    def self.asked_fields(params)
      params.select { |_field, mode| Params.asked?(mode) }.keys
    end

    private

    def fill(field, mode)
      if mode == "AUTO IP"
        @data[field] = @ip
      elsif Params.asked?(mode)
        fill_asked(field, mode)
      else
        @data[field] = mode # Fixed value
      end
    end

    def fill_asked(field, mode)
      value = @input[field].to_s.strip
      if value.empty? && password?(field) && @current.key?(field)
        @data[field] = @current[field] # Keep the old password
        return
      end
      return @errors << [field, "required"] if value.empty?

      error = Registration.value_error(field, value)
      return @errors << [field, error] unless error.nil?
      return @errors << [field, "email"] if mode == "AS EMAIL" && !value.match?(EMAIL)
      return @errors << [field, "own_ip"] if host?(field) && Network.own_ip?(value)

      @data[field] = value
    end

    def password?(field)
      field.include?("password")
    end

    def host?(field)
      field.end_with?("_ip", "_host")
    end
  end
end
