# frozen_string_literal: true

require "test_helper"

class NetworkTest < Test::Unit::TestCase
  test "normalize IPv4-mapped IPv6" do
    assert_equal "192.168.1.5", Teuton::Panel::Network.normalize("::ffff:192.168.1.5")
    assert_equal "10.0.0.1", Teuton::Panel::Network.normalize("10.0.0.1")
  end

  test "loopback addresses" do
    assert Teuton::Panel::Network.loopback?("127.0.0.1")
    assert Teuton::Panel::Network.loopback?("::1")
    assert Teuton::Panel::Network.loopback?("::ffff:127.0.0.1")
    assert Teuton::Panel::Network.loopback?("localhost")
    assert_equal false, Teuton::Panel::Network.loopback?("192.168.1.5")
  end

  test "own IPs include loopback and local addresses" do
    assert Teuton::Panel::Network.own_ip?("127.0.0.1")
    Teuton::Panel::Network.local_ips.each { assert Teuton::Panel::Network.own_ip?(_1) }
  end
end
