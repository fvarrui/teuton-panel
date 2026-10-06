# frozen_string_literal: true

require "socket"
require_relative "version"

module Teuton::Panel
  ##
  # IP helpers: normalize, loopback and the panel's own addresses
  module Network
    ##
    # Remove the IPv4-mapped IPv6 prefix (::ffff:192.168.1.5 -> 192.168.1.5)
    # @param ip (String)
    def self.normalize(ip)
      return "" if ip.nil?

      ip.to_s.sub(/\A::ffff:/i, "")
    end

    def self.loopback?(ip)
      ip = normalize(ip)
      return true if ip == "::1" || ip == "localhost"

      ip.start_with?("127.")
    end

    ##
    # Non-loopback IPv4 addresses of this machine
    def self.local_ips
      addrs = Socket.ip_address_list.select { |a| a.ipv4? && !a.ipv4_loopback? }
      addrs.map(&:ip_address).uniq
    end

    ##
    # True when ip is loopback or one of this machine's addresses
    def self.own_ip?(ip)
      return true if loopback?(ip)

      local_ips.include?(normalize(ip))
    end
  end
end
