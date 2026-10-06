# frozen_string_literal: true

require "sinatra/base"
require_relative "version"

module Teuton::Panel
  class App < Sinatra::Base
    set :bind, "0.0.0.0"
    set :port, 4567
    set :server, "webrick"

    get "/" do
      projects = settings.panel_projects
      output = "<h1>Teuton Panel</h1>"
      output += "<ul>"
      projects.each { |project| output += "<li>#{Rack::Utils.escape_html(project.name)}</li>" }
      output += "</ul>"
      output
    end
  end
end
