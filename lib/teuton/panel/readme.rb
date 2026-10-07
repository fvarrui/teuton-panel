# frozen_string_literal: true

require "kramdown"
require_relative "version"
require_relative "lang"
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

        text = tidy(mask(Runner.capture("readme", project, ["--lang=#{Lang::READMES[lang] || "en"}"])))
        @cache[key] = {stamp: stamp, text: text}
        text
      end
    end

    def self.html(project, lang)
      Kramdown::Document.new(markdown(project, lang)).to_html
    end

    ##
    # Make teuton readme output valid Kramdown (Teuton 3.0 writes GFM-like text):
    # ``` fences become ~~~, lists get the blank line they need after a paragraph,
    # and the hosts heading gets the id Teuton links to (#required-hosts)
    # @param text (String)
    def self.tidy(text)
      lines = text.lines.map { _1.sub(/\A```/, "~~~") }
      output = []
      lines.each do |line|
        previous = output.last.to_s
        list_item = line.match?(/\A\s*[*-] /)
        output << "\n" if list_item && !previous.strip.empty? && !previous.match?(/\A\s*[*-] /) && !previous.start_with?("#")
        output << line
      end
      table = output.index { _1.start_with?("| ID") }
      heading = table.nil? ? nil : output[0...table].rindex { _1.start_with?("#") }
      output[heading] = "#{output[heading].chomp} {#required-hosts}\n" unless heading.nil? || output[heading].include?("{#")
      output.join
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
