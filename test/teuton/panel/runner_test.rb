# frozen_string_literal: true

require "fileutils"
require "tmpdir"
require "test_helper"

# Runs the real teuton command on the teuton-sandbox test (a few seconds)
class RunnerTest < Test::Unit::TestCase
  SANDBOX = File.join(__dir__, "..", "..", "..", ".claude", "skills", "teuton-sandbox", "scripts", "create_sandbox.rb")

  def setup
    @tmpdir = Dir.mktmpdir
    basedir = File.join(@tmpdir, "sandbox")
    system(RbConfig.ruby, SANDBOX, basedir, out: File::NULL)
    capture_output { @config = Teuton::Panel::Config.new(basedir) }
    @project = Teuton::Panel::Projects.all(basedir).first
    @workspace = Teuton::Panel::Workspace.new(@config, @project)
  end

  def teardown
    FileUtils.rm_rf(@tmpdir)
  end

  test "cases skip disabled students and keep panel keys" do
    keys = Teuton::Panel::Runner.cases(@project).map { _1["tt_panel_key"] }
    assert_equal %w[AB3K CD4M EF5N], keys.sort
    assert_equal ["CD4M"], Teuton::Panel::Runner.cases(@project, ["CD4M", "GH6P"]).map { _1["tt_panel_key"] }
  end

  test "full run reads every case report" do
    summary = Teuton::Panel::Runner.new(@workspace).call("full")
    assert summary["ok"], File.read(File.join(@workspace.run_dir(summary["id"]), "output.log"))
    grades = summary["cases"].to_h { [_1["key"], _1["grade"]] }
    assert_equal({"AB3K" => 100.0, "CD4M" => 33.0, "EF5N" => 100.0}, grades)
    luis = summary["cases"].find { _1["key"] == "CD4M" }
    assert_equal "Luis", luis["members"]
    assert_equal 2, luis["targets"].size
    assert_equal false, luis["targets"][1]["check"]
  end

  test "a student run does not replace other results in the store" do
    store = Teuton::Panel::ResultsStore.new(@workspace.results_path)
    store.update(Teuton::Panel::Runner.new(@workspace).call("full"))
    store.update(Teuton::Panel::Runner.new(@workspace).call("student", ["CD4M"]))

    assert_equal 3, store.all.size
    assert_match "student", store.get("CD4M")["run_id"]
    assert_match "full", store.get("AB3K")["run_id"]
    assert_match "ana@example.com,100.0", store.moodle_csv
    assert_equal 2, @workspace.run_ids.size
  end

  test "queue runs jobs and rejects a second run of the same student" do
    queue = Teuton::Panel::RunQueue.new(2)
    job = queue.submit(@workspace, "student", ["AB3K"], "AB3K")
    assert_nil queue.submit(@workspace, "student", ["AB3K"], "AB3K")
    summary = job[:done].pop
    assert_equal 100.0, summary["cases"].first["grade"]
    assert_equal false, queue.busy?("AB3K")
  end
end
