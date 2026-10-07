# frozen_string_literal: true

require "time"
require_relative "../runner"
require_relative "../scheduler"

module Teuton::Panel
  # Teacher area: /teacher/... (localhost and allowed IPs only)
  class App < Sinatra::Base
    helpers do
      ##
      # Every case of the active test with its latest result, for tables
      def roster
        return [] if project.nil?

        rows = []
        project.config_cases.each_with_index do |data, index|
          rows << {key: "cfg-#{index + 1}", code: nil, data: data, disabled: false, source: "config.yaml"}
        end
        students.all.each do |student|
          key = student[:code] || "file-#{File.basename(student[:filepath], ".*")}"
          rows << {key: key, code: student[:code], data: student[:data], disabled: student[:disabled],
                   source: File.basename(student[:filepath]), filepath: student[:filepath], time: student[:time]}
        end
        rows.each { _1[:result] = store.get(_1[:key]) }
        rows
      end

      ##
      # Make the test ready for registration: tt_include and params file
      def prepare_test(test)
        TeutonConfig.ensure_include(test.configpath)
        return if Params.exists?(test)

        Params.save(test, Params.propose(Runner.capture("config", test)))
      end

      def run_log(summary)
        return "" if summary.nil?

        filepath = File.join(workspace.run_dir(summary["id"]), "output.log")
        File.exist?(filepath) ? File.read(filepath).lines.last(40).join : ""
      end

      def last_summary
        return nil if project.nil?

        History.runs(workspace.runs_dir).first
      end

      def results_json(rows)
        rows.map do |row|
          result = row[:result]
          {key: row[:key], code: row[:code], members: row[:data]["tt_members"].to_s, disabled: row[:disabled],
           status: state_key(row[:disabled], result),
           grade: result&.dig("grade"), connection: result.nil? ? nil : result["conn_status"],
           unique_fault: result.nil? ? false : result["unique_fault"].to_i > 0, finished_at: result&.dig("finished_at")}
        end
      end

      def editable_data(data)
        data.reject { |k, _v| k.start_with?("tt_panel_") }
      end
    end

    get "/teacher(.:format)?" do
      format!(%w[html json])
      status = {scheduler: scheduler.status, queue: queue.status, last: last_summary&.except("cases")}
      locals = {status: status, urls: Teuton::Panel.student_urls(config), rows: roster}
      respond(:"teacher/home", locals, {test: project&.name, urls: locals[:urls], scheduler: status[:scheduler], queue: status[:queue]})
    end

    get "/teacher/tests" do
      format!(%w[html])
      check = (params["check"] && !project.nil?) ? Runner.capture("check", project, ["--no-color"]) : nil
      erb :"teacher/tests", locals: {projects: settings.panel_projects, check: check}
    end

    post "/teacher/tests/select" do
      test = settings.panel_projects.find { _1.relpath(config.basedir) == params["test"] }
      halt 404, error_body(404, t("errors.not_found")) if test.nil?

      scheduler.stop
      prepare_test(test)
      config.update(test: test.relpath(config.basedir))
      redirect "/teacher/tests"
    end

    get "/teacher/registration" do
      format!(%w[html])
      project!
      erb :"teacher/registration", locals: {params_spec: Params.load(project), saved: params["saved"]}
    end

    post "/teacher/registration" do
      project!
      spec = {}
      (params["fields"] || {}).each_value do |row|
        field = row["name"].to_s.strip.gsub(/[^A-Za-z0-9_]/, "")
        next if field.empty? || row["delete"]

        mode = row["mode"].to_s
        mode = row["value"].to_s if mode == "FIXED"
        spec[field] = mode
      end
      spec = Params.propose(Runner.capture("config", project)) if params["propose"]
      Params.save(project, spec)
      redirect "/teacher/registration?saved=1"
    end

    get "/teacher/students(.:format)?" do
      format!(%w[html json])
      project!
      rows = roster
      respond(:"teacher/students", {rows: rows}, results_json(rows))
    end

    post "/teacher/students/assign" do
      project!
      filepath = students.all.find { _1[:filepath] == params["filepath"] && _1[:code].nil? }&.dig(:filepath)
      students.assign_code(filepath) unless filepath.nil?
      redirect "/teacher/students"
    end

    get "/teacher/students/:code" do
      format!(%w[html])
      project!
      student = students.find(params["code"])
      halt 404, error_body(404, t("errors.unknown_code")) if student.nil?

      erb :"teacher/student_edit", locals: {student: student, data: editable_data(student[:data]), errors: []}
    end

    post "/teacher/students/:code" do
      project!
      student = students.find(params["code"])
      halt 404, error_body(404, t("errors.unknown_code")) if student.nil?

      spec = Params.load(project)
      values = {}
      errors = []
      editable_data(student[:data]).each do |field, current|
        value = params.dig("data", field).to_s.strip
        values[field] = value
        next if value == current.to_s # Keeping a value is always allowed

        errors << field unless Registration.value_error(field, value).nil?
        asked = Params.asked?(spec[field].to_s)
        errors << field if asked && field.end_with?("_ip", "_host") && Network.own_ip?(value)
      end
      unless errors.empty?
        status 422
        return erb :"teacher/student_edit", locals: {student: student, data: values, errors: errors}
      end
      students.update(student[:code], values)
      redirect "/teacher/students"
    end

    post "/teacher/students/:code/delete" do
      project!
      students.delete(params["code"])
      redirect "/teacher/students"
    end

    post "/teacher/students/:code/disable" do
      project!
      students.disable(params["code"], params["value"] == "1")
      redirect "/teacher/students"
    end

    get "/teacher/run(.:format)?" do
      format!(%w[html json])
      project!
      summary = last_summary
      locals = {rows: roster, status: scheduler.status, queue: queue.status, settings_used: scheduler.settings,
                summary: summary, log: run_log(summary)}
      respond(:"teacher/run", locals, {scheduler: scheduler.status, queue: queue.status, last: summary&.except("cases")})
    end

    # Live status of /teacher/run, loaded in an iframe so the form is never reloaded
    get "/teacher/run/status" do
      project!
      summary = last_summary
      erb :"teacher/run_status", layout: :frame,
        locals: {status: scheduler.status, queue: queue.status, summary: summary, log: run_log(summary)}
    end

    post "/teacher/run/start" do
      project!
      keys = params["keys"].is_a?(Array) ? params["keys"] : nil
      enabled = roster.reject { _1[:disabled] }.map { _1[:key] }
      keys = nil if !keys.nil? && keys.sort == enabled.sort
      mode = Scheduler::MODES.include?(params["mode"]) ? params["mode"] : "once"
      args = {mode: mode, times: params["times"].to_i, every: [params["every"].to_i, 10].max,
              delay: params["delay"].to_i, keys: keys, until_time: nil}
      args[:until_time] = Time.parse(params["until"]) unless params["until"].to_s.strip.empty?
      config.update(run: {every: args[:every], times: [args[:times], 1].max, delay: args[:delay]})
      scheduler.start(workspace, args) { |summary| store.update(summary) }
      redirect "/teacher/run"
    end

    post "/teacher/run/stop" do
      scheduler.stop
      redirect "/teacher/run"
    end

    get "/teacher/runs" do
      format!(%w[html])
      project!
      erb :"teacher/runs", locals: {runs: History.runs(workspace.runs_dir)}
    end

    get "/teacher/runs/:id" do
      format!(%w[html])
      project!
      run = History.summary(workspace.run_dir(File.basename(params["id"])))
      halt 404, error_body(404, t("errors.not_found")) if run.nil?

      erb :"teacher/run_detail", locals: {run: run, log: run_log(run)}
    end

    get "/teacher/results(.:format)?" do
      format!(%w[html json])
      project!
      rows = roster
      projector = params["projector"] == "1"
      respond(:"teacher/results", {rows: rows, projector: projector, urls: Teuton::Panel.student_urls(config)}, results_json(rows))
    end

    get "/teacher/results/:key" do
      format!(%w[html])
      project!
      row = roster.find { _1[:key] == params["key"] }
      halt 404, error_body(404, t("errors.not_found")) if row.nil?

      erb :"teacher/result_detail", locals: {row: row, projector: params["projector"] == "1"}
    end

    get "/teacher/moodle.csv" do
      project!
      content_type "text/csv; charset=utf-8"
      attachment "#{project.name}-moodle.csv"
      store.moodle_csv
    end

    get "/teacher/readme" do
      format!(%w[html])
      project!
      erb :"teacher/readme", locals: {html: Readme.html(project, @lang)}
    end

    get "/teacher/settings" do
      format!(%w[html])
      erb :"teacher/settings", locals: {saved: params["saved"]}
    end

    post "/teacher/settings" do
      student = {}
      %w[register list run results feedback history status readme].each { student[_1.to_sym] = params.dig("student", _1) == "1" }
      student[:formats] = (params["formats"] || []).select { FORMATS.include?(_1) }
      student[:run_interval] = [params["run_interval"].to_i, 0].max
      allow = params["teacher_allow"].to_s.split(/[\s,]+/).map(&:strip).reject(&:empty?)
      addresses = params["addresses"].to_s.split(/[\s,]+/).map(&:strip).reject(&:empty?)
      language = Lang::LANGS.include?(params["language"]) ? params["language"] : config[:language]
      config.update(student: student, teacher: {allow: allow}, language: language, server: {addresses: addresses},
        runs: {max_parallel: [params["max_parallel"].to_i, 1].max})
      redirect "/teacher/settings?saved=1"
    end

    get "/teacher/sessions" do
      format!(%w[html])
      project!
      erb :"teacher/sessions", locals: {sessions: Sessions.new(workspace).list, error: params["error"]}
    end

    post "/teacher/sessions/new" do
      project!
      redirect "/teacher/sessions?error=running" if scheduler.active?

      Sessions.new(workspace).archive(params["label"])
      store.clear
      redirect "/teacher/sessions"
    end

    get "/teacher/sessions/:id" do
      format!(%w[html])
      project!
      sessions = Sessions.new(workspace)
      info = sessions.info(params["id"])
      halt 404, error_body(404, t("errors.not_found")) if info.nil?

      dirpath = sessions.dirpath(params["id"])
      archived = Students.new(File.join(dirpath, "config.d")).all
      results = ResultsStore.new(File.join(dirpath, "results.json"))
      erb :"teacher/session", locals: {info: info, archived: archived, results: results}
    end

    get "/teacher/sessions/:id/moodle.csv" do
      project!
      sessions = Sessions.new(workspace)
      halt 404 if sessions.info(params["id"]).nil?

      content_type "text/csv; charset=utf-8"
      attachment "#{project.name}-#{File.basename(params["id"])}-moodle.csv"
      ResultsStore.new(File.join(sessions.dirpath(params["id"]), "results.json")).moodle_csv
    end
  end
end
