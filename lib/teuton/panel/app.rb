# frozen_string_literal: true

require "json"
require "sinatra/base"
require_relative "version"
require_relative "history"
require_relative "lang"
require_relative "network"
require_relative "params"
require_relative "readme"
require_relative "registration"
require_relative "results_store"
require_relative "sessions"
require_relative "students"
require_relative "teuton_config"
require_relative "scheduler"
require_relative "workspace"

module Teuton::Panel
  ##
  # Web panel. Teacher area under /teacher (localhost and allowed IPs),
  # student area under /students (LAN). Format by URL suffix (ADR-005).
  class App < Sinatra::Base
    FORMATS = %w[html txt json]

    set :environment, :production # No host check, no stack traces for students
    set :bind, "0.0.0.0"
    set :port, 4567
    set :server, "webrick"
    set :views, File.join(__dir__, "views")
    set :public_folder, File.join(__dir__, "public")
    set :show_exceptions, false
    set :panel_stores, {}
    set :panel_lock, Mutex.new

    helpers do
      def config
        settings.panel_config
      end

      def t(key, vars = {})
        Lang.t(@lang, key, vars)
      end

      def h(text)
        Rack::Utils.escape_html(text.to_s)
      end

      def client_ip
        Network.normalize(request.ip)
      end

      def teacher_ip?
        ip = client_ip
        Network.own_ip?(ip) || config[:teacher][:allow].map(&:to_s).include?(ip)
      end

      ##
      # Active test (Project) or nil
      def project
        return nil if config[:test].nil?

        settings.panel_projects.find { _1.relpath(config.basedir) == config[:test] }
      end

      def workspace
        Workspace.new(config, project)
      end

      def store
        ws = workspace
        settings.panel_lock.synchronize do
          stores = settings.panel_stores
          stores[ws.slug] = ResultsStore.new(ws.results_path) if stores[ws.slug].nil?
          stores[ws.slug]
        end
      end

      def students
        Students.new(project&.include_dir)
      end

      def queue
        settings.panel_queue
      end

      def scheduler
        settings.panel_scheduler
      end

      ##
      # Read the URL suffix (html, txt, json); unknown suffix is 404
      # @param allowed (Array)
      def format!(allowed = FORMATS)
        @format = params["format"].to_s.empty? ? "html" : params["format"]
        halt 404 unless allowed.include?(@format)
      end

      ##
      # Student routes: also check the formats chosen by the teacher
      def student_format!(allowed = FORMATS)
        format!(allowed)
        formats = config[:student][:formats].map(&:to_s)
        return if formats.include?(@format)

        enabled = formats.map { (_1 == "html") ? "html" : ".#{_1}" }.join(", ")
        halt 403, {"Content-Type" => "text/plain; charset=utf-8"}, t("errors.format_disabled", formats: enabled) + "\n"
      end

      def feature!(name)
        return if config[:student][name]

        halt 403, error_body(403, t("errors.feature_disabled"))
      end

      def project!
        return unless project.nil?

        halt 409, error_body(409, t("errors.no_test"))
      end

      ##
      # Render in the requested format
      # @param view (Symbol) ERB view name, e.g. :"students/home"
      # @param locals (Hash)
      # @param json (Object) Data for .json
      def respond(view, locals = {}, json = nil)
        if @format == "json"
          content_type :json
          JSON.pretty_generate(json.nil? ? locals : json)
        elsif @format == "txt"
          content_type "text/plain; charset=utf-8"
          erb :"txt/#{view}", layout: false, locals: locals, trim: "-"
        else
          erb view, locals: locals
        end
      end

      def error_body(status, message)
        @format = "html" if @format.nil?
        respond(:error, {status: status, message: message}, {status: status, error: message})
      end

      def student_base_url
        "#{request.scheme}://#{request.host_with_port}/students"
      end

      def time_text(value)
        return "" if value.nil?

        Time.parse(value.to_s).strftime("%Y-%m-%d %H:%M:%S")
      rescue ArgumentError
        value.to_s
      end
    end

    before do
      lang = params["lang"].to_s
      if Lang::LANGS.include?(lang)
        response.set_cookie("lang", value: lang, path: "/", max_age: 31_536_000)
      else
        lang = request.cookies["lang"].to_s
        lang = Lang.detect(request.env["HTTP_ACCEPT_LANGUAGE"], config[:language].to_s) unless Lang::LANGS.include?(lang)
      end
      @lang = lang
    end

    before "/teacher*" do
      @area = "teacher"
      halt 403, error_body(403, t("errors.teacher_only")) unless teacher_ip?
    end

    before "/students*" do
      @area = "students"
      if config[:student][:formats].empty?
        halt 403, {"Content-Type" => "text/plain; charset=utf-8"}, t("errors.student_area_closed") + "\n"
      end
    end

    get "/" do
      redirect "/students"
    end

    not_found do
      error_body(404, t("errors.not_found"))
    end

    error do
      error_body(500, t("errors.internal"))
    end
  end
end

require_relative "app/teacher_routes"
require_relative "app/student_routes"
require_relative "app/view_helpers"
