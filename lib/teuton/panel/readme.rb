# frozen_string_literal: true

require "kramdown"
require_relative "version"
require_relative "runner"

module Teuton::Panel
  ##
  # Test statement from `teuton readme`, without passwords, as Markdown or HTML
  module Readme
    LOCK = Mutex.new

    ##
    # Markdown (cached until start.rb or config.yaml change)
    # @param project (Project)
    # @param lang (String) en or es
    def self.markdown(project, lang)
      stamp = [project.startpath, project.configpath].map { File.exist?(_1) ? File.mtime(_1).to_f : 0 }
      key = [project.dirpath, lang]
      LOCK.synchronize do
        @cache = {} if @cache.nil?
        cached = @cache[key]
        return cached[:text] if !cached.nil? && cached[:stamp] == stamp

        text = mask(Runner.capture("readme", project, ["--lang=#{lang}"]))
        @cache[key] = {stamp: stamp, text: text}
        text
      end
    end

    def self.html(project, lang)
      Kramdown::Document.new(markdown(project, lang)).to_html
    end

    ##
    # Hide password values and panel-only keys
    # @param text (String)
    def self.mask(text)
      text.lines.map do |line|
        if line.match?(/password/i)
          line.sub(/(password[^:|=]*[:=|]\s*)([^|\n]+)/i) { "#{Regexp.last_match(1)}******" }
        else
          line
        end
      end.join
    end
  end
end
