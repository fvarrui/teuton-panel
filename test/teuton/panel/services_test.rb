# frozen_string_literal: true

require "fileutils"
require "json"
require "tmpdir"
require "test_helper"

class ServicesTest < Test::Unit::TestCase
  # Queue double: every job finishes at once with an empty summary
  class FakeQueue
    attr_reader :jobs

    def initialize
      @jobs = []
    end

    def submit(_workspace, kind, keys, _code = nil, &block)
      summary = {"id" => "run-#{@jobs.size + 1}", "kind" => kind, "cases" => []}
      @jobs << keys
      block&.call(summary)
      done = Thread::Queue.new
      done << summary
      {done: done}
    end

    def kill_all
    end
  end

  def setup
    @tmpdir = Dir.mktmpdir
    testdir = File.join(@tmpdir, "test-a")
    FileUtils.mkdir_p(File.join(testdir, "config.d"))
    File.write(File.join(testdir, "start.rb"), "")
    File.write(File.join(testdir, "config.yaml"), "global:\n  tt_include: config.d\ncases: []\n")
    capture_output { @config = Teuton::Panel::Config.new(@tmpdir) }
    @project = Teuton::Panel::Project.new(testdir)
    @workspace = Teuton::Panel::Workspace.new(@config, @project)
  end

  def teardown
    FileUtils.rm_rf(@tmpdir)
  end

  def wait_idle(scheduler)
    50.times do
      break unless scheduler.active?

      sleep 0.05
    end
  end

  test "scheduler runs N times and stops" do
    queue = FakeQueue.new
    scheduler = Teuton::Panel::Scheduler.new(queue)
    scheduler.start(@workspace, {mode: "times", times: 3, delay: 0, keys: ["AB3K"]})
    wait_idle(scheduler)
    assert_equal 3, queue.jobs.size
    assert_equal false, scheduler.active?
  end

  test "scheduler every T keeps running until stopped" do
    queue = FakeQueue.new
    scheduler = Teuton::Panel::Scheduler.new(queue)
    scheduler.start(@workspace, {mode: "every", every: 60, keys: nil})
    sleep 0.2
    assert scheduler.active?
    assert_not_nil scheduler.status[:next_at]
    scheduler.stop
    assert_equal false, scheduler.active?
    assert_equal 1, queue.jobs.size
  end

  test "history reads run summaries" do
    %w[20261006-100000-000-full 20261006-110000-000-student].each_with_index do |id, i|
      dirpath = @workspace.run_dir(id)
      FileUtils.mkdir_p(dirpath)
      summary = {"id" => id, "kind" => "full", "finished_at" => "t#{i}", "cases" => [{"key" => "AB3K", "grade" => 50.0 + i * 25}]}
      File.write(File.join(dirpath, "summary.json"), JSON.generate(summary))
    end
    history = Teuton::Panel::History.for(@workspace.runs_dir, "AB3K")
    assert_equal [75.0, 50.0], history.map { _1["grade"] }
    assert_equal 75.0, Teuton::Panel::History.average(Teuton::Panel::History.runs(@workspace.runs_dir).first)
  end

  test "archive a session and list it" do
    Teuton::Panel::Students.new(@project.include_dir).create({"tt_members" => "Ana"}, "10.0.0.2")
    Teuton::Panel::ResultsStore.new(@workspace.results_path).update({"id" => "r1", "cases" => []})
    sessions = Teuton::Panel::Sessions.new(@workspace)
    id = sessions.archive("Group A")

    assert_equal [], Teuton::Panel::Students.new(@project.include_dir).all
    assert_equal false, File.exist?(@workspace.results_path)
    assert_equal "Group A", sessions.list.first["label"]
    assert_equal 1, Dir.glob(File.join(sessions.dirpath(id), "config.d", "*.yaml")).size
  end

  test "readme mask hides passwords" do
    text = "| 1 | HOST1 | username=root, password=s3cr3t |\n* host1_password: s3cr3t\n* host1_ip\n"
    masked = Teuton::Panel::Readme.mask(text)
    assert_no_match(/s3cr3t/, masked)
    assert_match "host1_ip", masked
  end
end
