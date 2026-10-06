# frozen_string_literal: true

require "test_helper"

class ConfigTest < Test::Unit::TestCase
  test "read existing panel config" do
    dirpath = File.join(File.dirname(__FILE__), "..", "..", "files", "t02-config-ok")
    config = Teuton::Panel::Config.new(dirpath)
    assert_equal 120, config[:run][:every]
  end
end
