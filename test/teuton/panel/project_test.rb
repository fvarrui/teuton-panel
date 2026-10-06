# frozen_string_literal: true

require "test_helper"

class ProjectTest < Test::Unit::TestCase
  def setup
    @basedir = File.join(File.dirname(__FILE__), "..", "..", "files", "t01-projects")
  end

  test "find every directory with a start.rb" do
    projects = Teuton::Panel::Projects.all(@basedir)
    assert_equal 2, projects.size
    assert_equal %w[alpha beta], projects.map(&:name)
  end

  test "find projects from a path with backslashes" do
    projects = Teuton::Panel::Projects.all(File.expand_path(@basedir).tr("/", "\\"))
    assert_equal 2, projects.size
  end

  test "no projects in an empty directory" do
    projects = Teuton::Panel::Projects.all(File.join(@basedir, "missing"))
    assert_equal [], projects
  end
end
