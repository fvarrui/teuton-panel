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
    app.set(:panel_stores, {})
    app.set(:panel_requests, {})
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
    assert_match "test-sandbox", last_response.body
    get "/students/readme", {}, REMOTE
    assert_match "<h1", last_response.body
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

    post "/teacher/sessions/new", {"label" => "Group A"}
    get "/teacher/results.json"
    assert_equal [], JSON.parse(last_response.body)
  end
end
