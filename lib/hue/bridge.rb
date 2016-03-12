module Hue
  class Bridge
    attr_reader :ip

    def initialize(options={})
      @ip = options[:bridge_ip] || get_bridge_info[:bridge_ip]
    end

    private

    def get_bridge_info
      Hue::BridgeLookup.bridge_info
    end
  end
end
