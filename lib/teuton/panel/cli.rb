# frozen_string_literal: true

require "thor"
require_relative "version"
require_relative "../panel"

class CLI < Thor
  map ["h", "-h", "--help"] => "help"

  map ["--up", "-u", "u"] => "up"
  desc "[up] [DIRECTORY]", "Run Teuton Panel from directory"
  long_desc <<~LONGDESC
    Start the web panel for the Teuton tests found under DIRECTORY.
    By default, the current directory will be used.

    (1) teuton-panel up PATH/TO/DIR, run the panel on that directory.
    (2) teuton-panel PATH/TO/DIR, same as (1).
    (3) teuton-panel up, run the panel on the current directory.
  LONGDESC
  def up(dirpath = ".")
    Teuton::Panel.up(dirpath)
  end

  map ["v", "-v", "--version"] => "version"
  desc "version", "Show the program version"
  def version
    puts "#{Teuton::Panel::APPNAME} version #{Teuton::Panel::VERSION}"
  end

  def self.exit_on_failure?
    true
  end

  ##
  # These inputs are equivalents:
  # * teuton-panel dir/foo
  # * teuton-panel up dir/foo
  def method_missing(method, *_args, &_block)
    up(method.to_s)
  end

  def respond_to_missing?(method_name, include_private = false)
    # Respond to missing methods name
    super
  end
end
