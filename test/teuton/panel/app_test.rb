# frozen_string_literal: true

require "fileutils"
require "json"
require "rack/test"
require "tmpdir"
require "test_helper"

# Web panel over the teuton-sandbox test (some tests run the real teuton)
class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  SANDBOX = File.join(__dir__, "..", "..", "..", ".claude", "skills", "teuton-sandbox", "scripts", "create_sandbox.rb")
  REMOTE = {"REMOTE_ADDR" => "192.168.1.50"}

  def app
    Teuton::Panel::App
  end

  def setup
    @tmpdir = Dir.mktmpdir
    @basedir = File.join(@tmpdir, "sandbox")
    system(RbConfig.ruby, SANDBOX, @basedir, out: File::NULL)
    capture_output { @config = Teuton::Panel::Config.new(@basedir) }
    @config.update(test: "test-sandbox")
    queue = Teuton::Panel::RunQueue.new(2)
    app.set(:panel_projects, Teuton::Panel::Projects.all(@basedir))
    app.set(:panel_config, @config)
    app.set(:panel_queue, queue)
    app.set(:panel_scheduler, Teuton::Panel::Scheduler.new(queue))
    # Sinatra merges hash settings, so clear them instead of setting {}
    app.settings.panel_stores.clear
    app.settings.panel_requests.clear
    app.settings.panel_run_states.clear
  end

  def teardown
    FileUtils.rm_rf(@tmpdir)
  end

  test "teacher area only from localhost or allowed IPs" do
    get "/teacher", {}, REMOTE
    assert_equal 403, last_response.status
    get "/teacher"
    assert_equal 200, last_response.status
    @config.update(teacher: {allow: ["192.168.1.50"]})
    get "/teacher", {}, REMOTE
    assert_equal 200, last_response.status
  end

  test "student home in html, txt and json" do
    get "/students", {}, REMOTE
    assert_equal 200, last_response.status
    assert_match "test-sandbox", last_response.body
    get "/students.txt", {}, REMOTE
    assert_match "text/plain", last_response.content_type
    assert_match "/run.txt", last_response.body
    get "/students.json", {}, REMOTE
    assert_equal "test-sandbox", JSON.parse(last_response.body)["test"]
    get "/students.xml", {}, REMOTE
    assert_equal 404, last_response.status
  end

  test "formats chosen by the teacher and closed area" do
    @config.update(student: {formats: ["txt"]})
    get "/students", {}, REMOTE
    assert_equal 403, last_response.status
    assert_match ".txt", last_response.body
    get "/students.txt", {}, REMOTE
    assert_equal 200, last_response.status
    @config.update(student: {formats: []})
    get "/students.txt", {}, REMOTE
    assert_equal 403, last_response.status
  end

  test "language from Accept-Language and ?lang" do
    get "/students", {}, REMOTE.merge("HTTP_ACCEPT_LANGUAGE" => "en-US,en;q=0.9")
    assert_match "Welcome to the lab", last_response.body
    get "/students?lang=es", {}, REMOTE
    assert_match "Bienvenido", last_response.body
    clear_cookies
    get "/students", {}, REMOTE.merge("HTTP_ACCEPT_LANGUAGE" => "ca-ES,ca;q=0.9")
    assert_match "Benvingut al laboratori", last_response.body
    get "/students/readme.md?lang=ca", {}, REMOTE
    assert_match "Máquinas", last_response.body # Statement falls back to Spanish
  end

  test "register from curl, open the personal page and update data" do
    get "/students/register.txt", {"tt_members" => "Rosa", "tt_moodle_id" => "rosa@example.com", "answer" => "4"}, REMOTE
    assert_equal 200, last_response.status
    code = last_response.body[/[A-HJKMNP-Z2-9]{4}/]
    assert_not_nil code
    file = File.join(@basedir, "test-sandbox", "config.d", "#{code}.yaml")
    assert_equal "192.168.1.50", YAML.load_file(file)["host1_ip"]

    get "/students/#{code}.json", {}, REMOTE
    assert_equal "Rosa", JSON.parse(last_response.body)["members"]

    post "/students/#{code}", {"tt_members" => "Rosa M.", "tt_moodle_id" => "rosa@example.com", "answer" => "5"}, REMOTE
    assert_equal "Rosa M.", YAML.load_file(file)["tt_members"]
  end

  test "registration errors and protected hosts" do
    get "/students/register.txt", {"tt_members" => "", "tt_moodle_id" => "bad", "answer" => "4"}, REMOTE
    assert_equal 422, last_response.status
    assert_match "tt_members", last_response.body
    @config.update(student: {register: false})
    get "/students/register.txt", {"tt_members" => "X"}, REMOTE
    assert_equal 403, last_response.status
  end

  test "student runs own case and sees results, history and status" do
    get "/students/AB3K/run.txt", {}, REMOTE
    assert_equal 200, last_response.status, last_response.body
    assert_match "100/100", last_response.body
    get "/students/AB3K/run.json", {}, REMOTE
    assert_equal "too_soon", JSON.parse(last_response.body)["state"]

    get "/students/AB3K/results.json", {}, REMOTE
    result = JSON.parse(last_response.body)["result"]
    assert_equal 100.0, result["grade"]
    assert_nil result["targets"] # feedback off by default
    get "/students/AB3K/history.txt", {}, REMOTE
    assert_match "100", last_response.body
    get "/students/AB3K/status.txt", {}, REMOTE
    assert_equal 200, last_response.status
  end

  test "disabled student cannot run and unknown code is 404" do
    get "/students/GH6P/run.json", {}, REMOTE
    assert_equal "disabled", JSON.parse(last_response.body)["state"]
    get "/students/ZZZZ.txt", {}, REMOTE
    assert_equal 404, last_response.status
    get "/students/register", {}, REMOTE
    assert_equal 200, last_response.status
  end

  test "readme as markdown and html" do
    get "/students/readme.md", {}, REMOTE
    assert_equal 200, last_response.status
    assert_no_match(/{#/, last_response.body)
    assert_match "test-sandbox", last_response.body
    get "/students/readme", {}, REMOTE
    assert_match "<h1", last_response.body
  end

  test "teacher home works without an active test" do
    FileUtils.mkdir_p(File.join(@basedir, "second"))
    File.write(File.join(@basedir, "second", "start.rb"), "")
    @config.update(test: nil)
    app.set(:panel_projects, Teuton::Panel::Projects.all(@basedir))
    get "/teacher"
    assert_equal 200, last_response.status
    assert_match "/teacher/tests", last_response.body
    get "/teacher/results"
    assert_equal 409, last_response.status
    assert_match "/teacher/tests", last_response.body
  end

  test "a missing active test is forgotten and a single test is selected" do
    @config.update(test: "renamed-folder")
    capture_output { Teuton::Panel.select_test(@config, Teuton::Panel::Projects.all(@basedir)) }
    assert_equal "test-sandbox", @config[:test]
  end

  test "teacher keeps a fixed localhost host when editing a student" do
    data = YAML.load_file(File.join(@basedir, "test-sandbox", "config.d", "AB3K.yaml"))
    data["answer"] = "5"
    post "/teacher/students/AB3K", {"data" => data.reject { |k, _v| k.start_with?("tt_panel_") }}
    assert last_response.redirect?, last_response.body[0, 200]
    assert_equal "5", YAML.load_file(File.join(@basedir, "test-sandbox", "config.d", "AB3K.yaml"))["answer"]
  end

  test "registration refuses quotes in typed values" do
    get "/students/register.txt", {"tt_members" => "Ana", "tt_moodle_id" => "ana@example.com", "answer" => "4'"}, REMOTE
    assert_equal 422, last_response.status
    assert_match "answer", last_response.body
  end

  test "root path by area" do
    get "/"
    assert_equal 302, last_response.status
    assert_match %r{/teacher\z}, last_response.location
    get "/", {}, REMOTE.merge("HTTP_ACCEPT" => "text/html,application/xhtml+xml")
    assert_match %r{/students\z}, last_response.location
    assert_match "/students", last_response.body # curl without -L sees where to go
    get "/", {}, REMOTE.merge("HTTP_ACCEPT" => "*/*")
    assert_equal 200, last_response.status
    assert_match "/run.txt", last_response.body
    get "/.json", {}, REMOTE
    assert_equal "test-sandbox", JSON.parse(last_response.body)["test"]

    @config.update(student: {formats: []})
    get "/"
    assert_match %r{/teacher\z}, last_response.location
    get "/", {}, REMOTE
    assert_equal 403, last_response.status
  end

  test "field labels and help replace the keys" do
    project = Teuton::Panel::Projects.all(@basedir).first
    post "/teacher/registration", {"fields" => {
      "0" => {"name" => "tt_members", "mode" => "AS NAME"},
      "1" => {"name" => "answer", "mode" => "ASK", "label" => "Your answer", "help" => "A number from 1 to 9"}
    }}
    assert last_response.redirect?
    text = File.read(Teuton::Panel::Params.filepath(project))
    assert_match "tt_members: \"AS NAME\"", text # short form without label
    assert_equal({"tt_members" => "AS NAME", "answer" => "ASK"}, Teuton::Panel::Params.load(project))
    assert_equal "Your answer", Teuton::Panel::Params.details(project)["answer"]["label"]

    get "/students/register", {}, REMOTE
    assert_match "Your answer", last_response.body
    assert_match "A number from 1 to 9", last_response.body
    assert_no_match(%r{<small>tt_members</small>}, last_response.body)

    post "/teacher/registration", {"fields" => {"0" => {"name" => "answer", "mode" => "ASK", "label" => "<b>"}}}
    assert_equal 422, last_response.status
  end

  test "teacher cannot change tt_source_ip" do
    file = File.join(@basedir, "test-sandbox", "config.d", "AB3K.yaml")
    data = YAML.load_file(file).reject { |k, _v| k.start_with?("tt_panel_") }
    before = data["tt_source_ip"]
    post "/teacher/students/AB3K", {"data" => data.merge("tt_source_ip" => "10.9.9.9")}
    assert last_response.redirect?
    assert_equal before, YAML.load_file(file)["tt_source_ip"]
  end

  test "students table sorts, filters and deletes from the edit page" do
    get "/teacher/students?sort=name&show=disabled"
    assert_equal 200, last_response.status
    assert_match "GH6P", last_response.body
    assert_no_match(/AB3K/, last_response.body)
    assert_no_match(%r{/delete"}, last_response.body) # no delete button in the table
    get "/teacher/students?sort=bogus&show=bogus"
    assert_equal 200, last_response.status
    assert_match "AB3K", last_response.body
    get "/teacher/students/AB3K"
    assert_match "/teacher/students/AB3K/delete", last_response.body
  end

  test "class summary of an empty class" do
    FileUtils.rm_f(Dir.glob(File.join(@basedir, "test-sandbox", "config.d", "*.yaml")))
    get "/teacher.json"
    summary = JSON.parse(last_response.body)["summary"]
    assert_nil summary["average"]
    assert_equal 0, summary["total"]
    get "/teacher"
    assert_equal 200, last_response.status
  end

  test "settings saved per section and the registered-list hint" do
    get "/teacher"
    assert_match "/teacher/settings#students", last_response.body
    get "/teacher/settings"
    assert_no_match(/placeholder="192/, last_response.body)
    post "/teacher/settings", {"section" => "panel", "student" => {"run" => "1"}, "formats" => ["html"], "language" => "es", "max_parallel" => "2"}
    assert_match "saved=panel#panel", last_response.location
    get "/teacher"
    assert_no_match(%r{/teacher/settings#students}, last_response.body) # list is off now
  end

  test "the browser remembers the student's code" do
    get "/students", {}, REMOTE
    assert_match "/students/register", last_response.body
    get "/students/AB3K", {}, REMOTE
    get "/students", {}, REMOTE
    nav = last_response.body[%r{<nav class="nav".*?</nav>}m]
    assert_match "href=\"/students/AB3K\"", nav # My page
    assert_no_match(%r{/students/register}, nav)
    assert_match "value=\"AB3K\"", last_response.body

    get "/students/forget", {}, REMOTE
    get "/students", {}, REMOTE
    assert_match "/students/register", last_response.body[%r{<nav class="nav".*?</nav>}m]

    set_cookie "code=ZZZZ"
    get "/students", {}, REMOTE
    assert_match "/students/register", last_response.body # unknown code ignored
    get "/students/AB3K.txt", {}, REMOTE
    assert_nil last_response.headers["Set-Cookie"]&.match(/code=/) # curl is unchanged
  end

  test "browser run: post, redirect and a state page that never runs again" do
    post "/students/AB3K/run", {}, REMOTE
    assert last_response.redirect?
    assert_match "/students/AB3K/run?view=1", last_response.location
    get "/students/AB3K/run?view=1", {}, REMOTE
    if last_response.body.include?("http-equiv=\"refresh\"")
      assert_match "url=/students/AB3K/run?view=1", last_response.body # pending: reloads the state view
      100.times do
        break unless app.settings.panel_queue.busy?("AB3K")

        sleep 0.2
      end
      get "/students/AB3K/run?view=1", {}, REMOTE
    end
    assert_no_match(/http-equiv="refresh"/, last_response.body)
    assert_match "100", last_response.body
    get "/students/AB3K/run?view=1", {}, REMOTE # reloading the result queues nothing
    assert_equal false, app.settings.panel_queue.busy?("AB3K")
    assert_no_match(/class="run-again"/, last_response.body) # run again is too soon (30 s)
  end

  test "one menu tab is current" do
    current = -> { last_response.body.scan(/<a href="([^"]+)" class="current" aria-current="page"/).flatten }
    get "/teacher/runs"
    assert_equal ["/teacher/runs"], current.call
    get "/teacher/run"
    assert_equal ["/teacher/run"], current.call
    get "/students/register", {}, REMOTE
    assert_equal ["/students/register"], current.call
    get "/students", {}, REMOTE
    assert_equal ["/students"], current.call
  end

  test "run picker lists students with filters and ignores unknown values" do
    get "/teacher/run?show=bogus&sort=bogus"
    assert_equal 200, last_response.status
    assert_match "pick-table", last_response.body
    assert_match 'value="AB3K" id="pick-AB3K" checked', last_response.body
    assert_match "GH6P", last_response.body # disabled, shown greyed
    assert_no_match(/value="GH6P"/, last_response.body) # but not selectable
    get "/teacher/run?show=connection"
    assert_no_match(/name="keys\[\]" value=/, last_response.body) # nobody with connection problems yet
  end

  test "run page keeps the form and refreshes only its status" do
    get "/teacher/run"
    assert_no_match(/http-equiv="refresh"/, last_response.body)
    assert_match "run-group times", last_response.body
    assert_match "/teacher/run/status", last_response.body
    get "/teacher/run/status"
    assert_no_match(/http-equiv="refresh"/, last_response.body)

    post "/teacher/run/start", {"mode" => "every", "every" => "60"}
    get "/teacher/run"
    assert_no_match(%r{/teacher/run/start}, last_response.body) # no second start while a loop runs
    get "/teacher/run/status"
    assert_match "http-equiv=\"refresh\"", last_response.body
    assert_match "/teacher/run/stop", last_response.body
  ensure
    app.settings.panel_scheduler.stop
  end

  test "teacher pages render" do
    ["/teacher", "/teacher/tests", "/teacher/registration", "/teacher/students", "/teacher/students/AB3K",
      "/teacher/run", "/teacher/runs", "/teacher/results", "/teacher/results?projector=1", "/teacher/readme",
      "/teacher/settings", "/teacher/sessions", "/teacher/moodle.csv", "/teacher/results.json"].each do |path|
      get path
      assert_equal 200, last_response.status, "#{path}: #{last_response.body[0, 300]}"
    end
  end

  test "teacher manages students, settings and registration fields" do
    post "/teacher/students/CD4M/disable", {"value" => "1"}
    assert_equal true, YAML.load_file(File.join(@basedir, "test-sandbox", "config.d", "CD4M.yaml"))["tt_panel_disabled"]
    post "/teacher/students/CD4M/delete"
    assert_equal false, File.exist?(File.join(@basedir, "test-sandbox", "config.d", "CD4M.yaml"))

    post "/teacher/settings", {"student" => {"register" => "1", "run" => "1"}, "formats" => ["txt"], "run_interval" => "5", "language" => "en", "max_parallel" => "3"}
    again = Teuton::Panel::Config.new(@basedir)
    assert_equal ["txt"], again[:student][:formats]
    assert_equal false, again[:student][:list]

    post "/teacher/registration", {"fields" => {"0" => {"name" => "tt_members", "mode" => "AS NAME"}, "1" => {"name" => "host1_username", "mode" => "FIXED", "value" => "root"}}}
    project = Teuton::Panel::Projects.all(@basedir).first
    assert_equal({"tt_members" => "AS NAME", "host1_username" => "root"}, Teuton::Panel::Params.load(project))
  end

  test "teacher run once and new session" do
    post "/teacher/run/start", {"mode" => "once"}
    scheduler = app.settings.panel_scheduler
    100.times do
      break unless scheduler.active?

      sleep 0.2
    end
    get "/teacher/results.json"
    grades = JSON.parse(last_response.body).to_h { [_1["key"], _1["grade"]] }
    assert_equal 33.0, grades["CD4M"]
    assert_nil grades["GH6P"]
    states = JSON.parse(last_response.body).to_h { [_1["key"], _1["status"]] }
    assert_equal "needs_work", states["CD4M"]
    assert_equal "disabled", states["GH6P"]

    rows = JSON.parse(last_response.body).reject { _1["disabled"] }
    get "/teacher.json"
    summary = JSON.parse(last_response.body)["summary"]
    assert_equal rows.count { _1["grade"].to_f >= 50 }, summary["passed"]
    assert_equal rows.count { _1["grade"].nil? }, summary["pending"]
    assert_equal rows.size, summary["total"]

    get "/teacher/results"
    evaluated = last_response.body.scan(%r{href="/teacher/results/([^"?]+)"}).flatten
    get "/teacher/results/#{evaluated.first}"
    assert_no_match(/rel="prev"/, last_response.body)
    assert_match "/teacher/results/#{evaluated[1]}\" rel=\"next\"", last_response.body
    get "/teacher/results/#{evaluated.last}"
    assert_no_match(/rel="next"/, last_response.body)

    # Run picker: the needs-work filter lists only those students, ticked, and runs exactly them
    needs_work = states.select { |_key, state| state == "needs_work" }.keys
    get "/teacher/run?show=needs_work&sort=grade"
    picked = last_response.body.scan(/name="keys\[\]" value="([^"]+)"/).flatten
    assert_equal needs_work.sort, picked.sort
    assert_no_match(/value="GH6P"/, last_response.body) # disabled students only under "All"
    post "/teacher/run/start", {"mode" => "once", "keys" => picked}
    100.times do
      break unless scheduler.active?

      sleep 0.2
    end
    project = Teuton::Panel::Projects.all(@basedir).first
    last = Teuton::Panel::History.runs(Teuton::Panel::Workspace.new(@config, project).runs_dir).first
    assert_equal "selection", last["kind"]
    assert_equal needs_work.sort, last["cases"].map { _1["key"] }.sort

    post "/teacher/sessions/new", {"label" => "Group A"}
    get "/teacher/results.json"
    assert_equal [], JSON.parse(last_response.body)
  end
end
