# frozen_string_literal: true

require "fileutils"
require "tmpdir"
require "test_helper"

class ConfigTest < Test::Unit::TestCase
  def setup
    @tmpdir = Dir.mktmpdir
  end

  def teardown
    FileUtils.rm_rf(@tmpdir)
  end

  test "read existing panel config merged with defaults" do
    dirpath = File.join(File.dirname(__FILE__), "..", "..", "files", "t02-config-ok")
    config = Teuton::Panel::Config.new(dirpath)
    assert_equal 120, config[:run][:every]
    assert_equal 4567, config[:server][:port]
    assert_equal %w[html txt json], config[:student][:formats]
  end

  test "create the file with defaults when missing" do
    config = nil
    capture_output { config = Teuton::Panel::Config.new(@tmpdir) }
    assert File.exist?(File.join(@tmpdir, "teuton-panel.yaml"))
    assert_equal "es", config[:language]
  end

  test "update merges and saves immediately" do
    config = nil
    capture_output { config = Teuton::Panel::Config.new(@tmpdir) }
    config.update(student: {run: false}, language: "en")

    again = Teuton::Panel::Config.new(@tmpdir)
    assert_equal false, again[:student][:run]
    assert_equal true, again[:student][:register]
    assert_equal "en", again[:language]
  end

  test "student URLs use the configured addresses" do
    config = nil
    capture_output { config = Teuton::Panel::Config.new(@tmpdir) }
    config.update(server: {addresses: ["192.168.1.10"]})
    assert_equal ["http://192.168.1.10:4567/students"], Teuton::Panel.student_urls(config)
  end

  test "datapath is inside the data dir" do
    config = nil
    capture_output { config = Teuton::Panel::Config.new(@tmpdir) }
    assert_equal File.join(File.expand_path(@tmpdir), ".teuton-panel", "runs"), config.datapath("runs")
  end
end
