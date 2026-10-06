# frozen_string_literal: true

require "test_helper"

class Teuton::PanelTest < Test::Unit::TestCase
  test "VERSION" do
    assert ::Teuton::Panel.const_defined?(:VERSION)
  end

  test "APPNAME and CONFIGFILE" do
    assert_equal "teuton-panel", Teuton::Panel::APPNAME
    assert_equal "teuton-panel.yaml", Teuton::Panel::CONFIGFILE
  end
end
