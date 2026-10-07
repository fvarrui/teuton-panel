# frozen_string_literal: true

require "kramdown"
require_relative "version"
require_relative "lang"
require_relative "params"
require_relative "registration"
require_relative "runner"

module Teuton::Panel
  ##
  # Test statement from `teuton readme`, without passwords, as Markdown or HTML
  module Readme
    LOCK = Mutex.new
    LOCAL_HOSTS = %w[localhost 127.0.0.1 ::1]

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
    # Statement as students see it: the task only (see clean)
    # @param project (Project)
    # @param lang (String)
    def self.student_markdown(project, lang)
      spec = Params.load(project)
      hosts = spec.select { |field, _mode| field.match?(/\Ahost\d+_ip\z/) }
      local = !hosts.empty? && hosts.values.all? { LOCAL_HOSTS.include?(_1) }
      clean(markdown(project, lang), Registration.asked_fields(spec), local)
    end

    def self.student_html(project, lang)
      Kramdown::Document.new(student_markdown(project, lang)).to_html
    end

    ##
    # Drop what only matters to the teacher: the date/version block at the top,
    # internal parameters students do not type, and the SSH note on local hosts
    # @param text (String) tidied Markdown
    # @param typed (Array) fields students type at registration
    # @param local (Boolean) every host of the test is this machine
    def self.clean(text, typed, local)
      lines = text.lines
      if lines.first.to_s.start_with?("~~~")
        close = lines[1..].index { _1.start_with?("~~~") }
        lines = lines[(close + 2)..] unless close.nil?
      end
      lines = lines.reject { _1.start_with?(">") && _1.include?("SSH") } if local
      output = []
      index = 0
      while index < lines.size
        line = lines[index]
        items = lines[(index + 1)..].take_while { _1.match?(/\A\s*\* [A-Za-z0-9_]+\s*\z/) || _1.strip.empty? }
        if line.start_with?("#") && items.any? { _1.start_with?("*") } # A list of parameter names
          kept = items.select { _1.start_with?("*") && typed.include?(_1.sub("*", "").strip) }
          output << line << "\n" << kept.join << "\n" unless kept.empty?
          index += items.size + 1
          next
        end
        output << line
        index += 1
      end
      output.join.sub(/\A\s+/, "")
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
