# frozen_string_literal: true

require "fileutils"
require "tmpdir"
require "test_helper"

class DomainTest < Test::Unit::TestCase
  def setup
    @tmpdir = Dir.mktmpdir
    @testdir = File.join(@tmpdir, "test-a")
    FileUtils.mkdir_p(@testdir)
    File.write(File.join(@testdir, "start.rb"), "")
    @project = Teuton::Panel::Project.new(@testdir)
  end

  def teardown
    FileUtils.rm_rf(@tmpdir)
  end

  test "create config.yaml with tt_include when missing" do
    dirpath = Teuton::Panel::TeutonConfig.ensure_include(@project.configpath)
    assert_equal File.join(@testdir, "config.d"), dirpath
    assert Dir.exist?(dirpath)
    assert_equal [], @project.config_cases
  end

  test "insert tt_include keeping comments" do
    File.write(@project.configpath, "# my notes\nglobal:\n  host1_username: root # same for all\ncases:\n- tt_members: Fixed\n")
    Teuton::Panel::TeutonConfig.ensure_include(@project.configpath)
    content = File.read(@project.configpath)
    assert_match "# my notes", content
    assert_match "# same for all", content
    assert_equal File.join(@testdir, "config.d"), @project.include_dir
    assert_equal 1, @project.config_cases.size
  end

  test "insert tt_include when global is empty or missing" do
    File.write(@project.configpath, "global:\ncases: []\n")
    Teuton::Panel::TeutonConfig.ensure_include(@project.configpath)
    assert_equal File.join(@testdir, "config.d"), @project.include_dir

    File.write(@project.configpath, "cases: []\n")
    Teuton::Panel::TeutonConfig.ensure_include(@project.configpath)
    assert_equal File.join(@testdir, "config.d"), @project.include_dir
  end

  test "params save, load and propose" do
    params = {"tt_members" => "AS NAME", "host1_ip" => "AUTO IP", "host1_username" => "root"}
    Teuton::Panel::Params.save(@project, params)
    assert_equal params, Teuton::Panel::Params.load(@project)

    proposal = Teuton::Panel::Params.propose("---\ncases:\n- :tt_members: TOCHANGE\n  :host1_ip: TOCHANGE\n  :username: TOCHANGE\n")
    assert_equal({"tt_members" => "AS NAME", "host1_ip" => "AUTO IP", "username" => "ASK"}, proposal)
  end

  test "students create, find, update, disable and delete" do
    students = Teuton::Panel::Students.new(File.join(@testdir, "config.d"))
    code = students.create({"tt_members" => "Ana"}, "192.168.1.20")
    assert Teuton::Panel::Students.code?(code)
    assert File.exist?(File.join(@testdir, "config.d", "#{code}.yaml"))

    student = students.find(code)
    assert_equal "Ana", student[:data]["tt_members"]
    assert_equal "192.168.1.20", student[:data]["tt_source_ip"]

    students.update(code, {"tt_members" => "Ana Pérez"})
    assert_equal "Ana Pérez", students.find(code)[:data]["tt_members"]

    students.disable(code, true)
    assert students.find(code)[:disabled]
    students.disable(code, false)
    assert_equal false, students.find(code)[:disabled]

    assert students.delete(code)
    assert_nil students.find(code)
  end

  test "codes avoid ambiguous characters" do
    assert Teuton::Panel::Students.code?("K7QH")
    assert_equal false, Teuton::Panel::Students.code?("K0QH")
    assert_equal false, Teuton::Panel::Students.code?("register")
  end

  test "registration fills, validates and protects host fields" do
    params = {"tt_members" => "AS NAME", "tt_moodle_id" => "AS EMAIL", "host1_ip" => "AUTO IP", "host1_username" => "root", "host2_ip" => "ASK"}
    input = {"tt_members" => "Ana", "tt_moodle_id" => "ana@example.com", "host2_ip" => "192.168.1.30", "tt_panel_code" => "HACK"}
    reg = Teuton::Panel::Registration.new(params, input, "::ffff:192.168.1.20").call
    assert reg.ok?
    assert_equal "192.168.1.20", reg.data["host1_ip"]
    assert_equal "root", reg.data["host1_username"]
    assert_nil reg.data["tt_panel_code"]

    bad = Teuton::Panel::Registration.new(params, {"tt_moodle_id" => "nope", "host2_ip" => "127.0.0.1"}, "192.168.1.20").call
    assert_equal false, bad.ok?
    assert_equal [["tt_members", "required"], ["tt_moodle_id", "email"], ["host2_ip", "own_ip"]], bad.errors
  end

  test "empty password keeps the current one when updating" do
    params = {"tt_members" => "AS NAME", "host1_password" => "ASK"}
    reg = Teuton::Panel::Registration.new(params, {"tt_members" => "Ana"}, "192.168.1.20", {"host1_password" => "secret"}).call
    assert reg.ok?
    assert_equal "secret", reg.data["host1_password"]
  end
end
