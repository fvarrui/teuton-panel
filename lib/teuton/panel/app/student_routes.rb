# frozen_string_literal: true

require "time"

module Teuton::Panel
  # Student area: /students/... (LAN). Personal routes use the code in the path.
  class App < Sinatra::Base
    WAIT_SECONDS = 120 # How long a run request waits for its result

    set :panel_requests, {} # Last run request time by code and by IP
    set :panel_run_states, {} # Outcome of the last browser run request by code

    helpers do
      ##
      # Student of the code in the path, or 404
      def student!
        code = params["code"].to_s
        found = (Students.code?(code) && !project.nil?) ? students.find(code) : nil
        halt 404, error_body(404, t("errors.unknown_code")) if found.nil?
        found
      end

      ##
      # Student whose code the browser remembers (cookie), or nil; an unknown code is forgotten
      def remembered_student
        return @remembered if defined?(@remembered)

        code = request.cookies["code"].to_s
        @remembered = (Students.code?(code) && !project.nil?) ? students.find(code) : nil
        forget_student if @remembered.nil? && !code.empty?
        @remembered
      end

      ##
      # Remember the code in the browser: a shortcut, not a login (ADR-004)
      def remember_student(code)
        response.set_cookie("code", value: code, path: "/", max_age: 31_536_000, httponly: true, same_site: :lax)
        @remembered = students.find(code)
      end

      def forget_student
        response.delete_cookie("code", path: "/")
        @remembered = nil
      end

      def registration_fields
        Registration.asked_fields(Params.load(project))
      end

      def public_data(student)
        data = student[:data].reject { |k, _v| k.start_with?("tt_panel_") }
        data.to_h { |k, v| [k, k.include?("password") ? "******" : v] }
      end

      ##
      # Latest result as students may see it (no commands, output or config)
      def public_result(result)
        return nil if result.nil?

        view = {"grade" => result["grade"], "finished_at" => result["finished_at"]}
        view["unique_fault"] = result["unique_fault"].to_i > 0
        view["connection"] = result["conn_status"].empty? ? "ok" : result["conn_status"].values.uniq.join(", ")
        if config[:student][:feedback]
          view["targets"] = result["targets"].map { {"description" => _1["description"], "check" => _1["check"]} }
        end
        view
      end

      def too_soon(code)
        interval = config[:student][:run_interval].to_i
        requests = settings.panel_requests
        times = [requests["code:#{code}"], requests["ip:#{client_ip}"]].compact
        return 0 if times.empty?

        left = interval - (Time.now - times.max)
        (left > 0) ? left.ceil : 0
      end

      def remember_request(code)
        settings.panel_requests["code:#{code}"] = Time.now
        settings.panel_requests["ip:#{client_ip}"] = Time.now
      end

      ##
      # Queue a student run unless something stops it
      # @return [state, wait, job] state: disabled, next_pass, too_soon, busy or submitted
      def submit_run(student)
        code = student[:code]
        return ["disabled", 0, nil] if student[:disabled]
        return ["next_pass", 0, nil] if scheduler.active?

        wait = too_soon(code)
        return ["too_soon", wait, nil] if wait > 0

        remember_request(code)
        job = queue.submit(workspace, "student", [code], code) { |summary| store.update(summary) }
        return ["busy", 0, nil] if job.nil?

        ["submitted", 0, job]
      end

      ##
      # Browser: POST queues and redirects to the state page (Post/Redirect/Get),
      # GET ?view=1 shows the state. Otherwise (curl, plain GET) wait for the result.
      def run_request
        student_format!
        feature!(:run)
        student = student!
        return run_post_html(student) if request.post? && @format == "html"
        return run_view(student) if params["view"] && @format == "html"

        state, wait, job = submit_run(student)
        if state == "submitted"
          summary = job[:done].pop(timeout: WAIT_SECONDS)
          state = summary.nil? ? "queued" : "done"
        end
        run_response(student, state, wait)
      end

      def run_post_html(student)
        state, wait, _job = submit_run(student)
        settings.panel_run_states[student[:code]] = {state: state, wait: wait}
        redirect "/students/#{student[:code]}/run?view=1"
      end

      ##
      # State of the last browser request, refreshed while the run is pending
      def run_view(student)
        code = student[:code]
        state = (settings.panel_run_states[code] || {state: "done"})[:state]
        state = if queue.busy?(code)
          "running"
        elsif %w[submitted busy queued].include?(state) || (state == "next_pass" && !scheduler.active?)
          "done"
        else
          state
        end
        run_response(student, state, (state == "too_soon") ? too_soon(code) : 0)
      end

      def run_response(student, state, wait)
        code = student[:code]
        next_at = scheduler.status[:next_at]
        result = (state == "done") ? public_result(store.get(code)) : nil
        state = "failed" if state == "done" && result.nil?
        locals = {student: student, state: state, wait: wait, next_at: next_at, result: result}
        respond(:"students/run", locals, {code: code, state: state, wait: wait, next_at: next_at&.to_s, result: result})
      end

      ##
      # Student home (/students, and / for curl)
      # @param format (String|nil) html, txt or json
      def student_home(format)
        student_area!
        params["format"] = format
        student_format!
        list = (config[:student][:list] && !project.nil?) ? students.all : nil
        members = list&.map { {"members" => _1[:data]["tt_members"].to_s, "registered_at" => _1[:time].to_s} }
        respond(:"students/home", {members: members}, {test: project&.name, members: members})
      end

      def register_student
        feature!(:register)
        project!
        spec = Params.load(project)
        halt 409, error_body(409, t("errors.registration_not_ready")) if Registration.asked_fields(spec).empty? && spec.empty?

        reg = Registration.new(spec, params, client_ip).call
        unless reg.ok?
          status 422
          return respond(:"students/register", {fields: registration_fields, errors: reg.errors, values: params},
            {errors: reg.errors.map { |f, e| {field: f, error: e} }})
        end
        code = students.create(reg.data, client_ip)
        remember_student(code) if @format == "html"
        url = "#{student_base_url}/#{code}"
        respond(:"students/registered", {code: code, url: url}, {code: code, url: url})
      end
    end

    get "/students(.:format)?" do
      student_home(params["format"])
    end

    get "/students/go" do
      code = params["code"].to_s.strip.upcase
      redirect "/students/#{code}" if Students.code?(code)

      redirect "/students"
    end

    get "/students/forget" do
      forget_student
      redirect "/students"
    end

    get "/students/register(.:format)?" do
      student_format!
      project!
      return register_student if registration_fields.any? { params.key?(_1) }

      feature!(:register)
      respond(:"students/register", {fields: registration_fields, errors: [], values: {}}, {fields: registration_fields})
    end

    post "/students/register(.:format)?" do
      student_format!
      register_student
    end

    get "/students/readme(.:format)?" do
      readme_format = (params["format"] == "md") ? "txt" : params["format"]
      params["format"] = readme_format
      student_format!
      feature!(:readme)
      project!
      markdown = Readme.markdown(project, @lang)
      respond(:"students/readme", {html: Kramdown::Document.new(markdown).to_html, markdown: markdown}, {markdown: markdown})
    end

    get "/students/:code(.:format)?" do
      student_format!
      student = student!
      remember_student(student[:code]) if @format == "html"
      result = public_result(store.get(student[:code]))
      respond(:"students/personal", {student: student, data: public_data(student), result: result, fields: registration_fields, notice: nil},
        {code: student[:code], members: student[:data]["tt_members"], disabled: student[:disabled], data: public_data(student), result: result})
    end

    post "/students/:code(.:format)?" do
      student_format!
      feature!(:register)
      student = student!
      reg = Registration.new(Params.load(project), params, client_ip, student[:data]).call
      notice = "updated"
      if reg.ok?
        students.update(student[:code], reg.data)
        student = students.find(student[:code])
      else
        status 422
        notice = "invalid"
      end
      result = public_result(store.get(student[:code]))
      respond(:"students/personal", {student: student, data: public_data(student), result: result, fields: registration_fields, notice: notice},
        {code: student[:code], updated: reg.ok?, errors: reg.errors.map { |f, e| {field: f, error: e} }})
    end

    get "/students/:code/run(.:format)?" do
      run_request
    end

    post "/students/:code/run(.:format)?" do
      run_request
    end

    get "/students/:code/results(.:format)?" do
      student_format!
      feature!(:results)
      student = student!
      result = public_result(store.get(student[:code]))
      respond(:"students/results", {student: student, result: result}, {code: student[:code], result: result})
    end

    get "/students/:code/history(.:format)?" do
      student_format!
      feature!(:history)
      student = student!
      runs = History.for(workspace.runs_dir, student[:code])
      respond(:"students/history", {student: student, runs: runs}, {code: student[:code], runs: runs})
    end

    get "/students/:code/status(.:format)?" do
      student_format!
      feature!(:status)
      student = student!
      result = public_result(store.get(student[:code]))
      respond(:"students/status", {student: student, result: result},
        {code: student[:code], disabled: student[:disabled], connection: result&.dig("connection"), finished_at: result&.dig("finished_at")})
    end
  end
end
