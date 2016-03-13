module Hue
  class BridgeLookup
    include HTTParty
    base_uri 'http://www.meethue.com/api'

    class << self
      def ip
        @ip ||= cached_ip || query_bridge_discovery
      end

      private

      def cached_ip
        ENV['HUE_IP']
      end

      def query_bridge_discovery
        get('/nupnp').parsed_response.first['internalipaddress']
      end
    end
  end
end

