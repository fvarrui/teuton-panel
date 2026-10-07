# frozen_string_literal: true

require "yaml"
require_relative "version"

module Teuton::Panel
  ##
  # GUI texts from locales/<lang>.yml (en, es, ca)
  module Lang
    LANGS = %w[en es ca]
    READMES = {"en" => "en", "es" => "es", "ca" => "es"} # teuton readme has no Catalan
    DEFAULT = "en" # Fallback for missing keys

    def self.texts
      @texts = load if @texts.nil?
      @texts
    end

    ##
    # Translate a dotted key, replacing %{name} with vars[:name]
    # @param lang (String) en or es
    # @param key (String|Symbol) e.g. "students.title"
    # @param vars (Hash)
    def self.t(lang, key, vars = {})
      text = lookup(lang, key)
      text = lookup(DEFAULT, key) if text.nil?
      if text.nil?
        warn "[WARN] Lang.t: missing key <#{key}>"
        return key.to_s
      end
      text.gsub(/%\{(\w+)\}/) { vars[Regexp.last_match(1).to_sym].to_s }
    end

    ##
    # Best language for an Accept-Language header
    # @param header (String) e.g. "es-ES,es;q=0.9,en;q=0.8"
    # @param fallback (String)
    def self.detect(header, fallback)
      return fallback if header.nil? || header.empty?

      ranked = header.split(",").map do |part|
        code, quality = part.strip.split(";q=")
        [code.to_s[0, 2].downcase, (quality || "1").to_f]
      end
      best = ranked.sort_by { -_1[1] }.find { LANGS.include?(_1[0]) }
      return fallback if best.nil?

      best[0]
    end

    def self.lookup(lang, key)
      value = texts[lang]
      key.to_s.split(".").each do |part|
        return nil unless value.is_a?(Hash)

        value = value[part]
      end
      value.is_a?(String) ? value : nil
    end

    def self.load
      dirpath = File.join(__dir__, "locales")
      LANGS.to_h { [_1, YAML.load_file(File.join(dirpath, "#{_1}.yml"))] }
    end
  end
end
