# frozen_string_literal: true

require_relative "panel/version"
require_relative "panel/app"
require_relative "panel/config"
require_relative "panel/project"

module Teuton::Panel
  ##
  # Start the panel from the base directory
  # @param basedir (String) Directory with Teuton tests
  def self.up(basedir)
    projects = Projects.all(basedir)
    if projects.empty?
      warn "[ERROR] Teuton::Panel.up: No Teuton tests found! <#{basedir}>"
      warn "[ERROR] Create one with 'teuton new DIRECTORY' and try again."
      exit 1
    end
    config = Config.new(basedir)

    App.set(:panel_projects, projects)
    App.set(:panel_config, config)
    App.run!
  end
end
