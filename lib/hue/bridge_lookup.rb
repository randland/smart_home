module Hue
  class BridgeLookup
    include HTTParty
    base_uri 'https://www.meethue.com/api'

    def self.bridge_info
      raw_info = parse_response(get_info)

      {
        bridge_id: raw_info['id'],
        bridge_ip: raw_info['internalipaddress']
      }.with_indifferent_access
    end

    private

    def self.get_info
      get('/nupnp')
    end

    def self.parse_response(response)
      JSON.parse(response.body).first
    end
  end
end
