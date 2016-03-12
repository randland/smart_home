module Hue
  class Light < DataModel
    property :id,
      coerce: String

    property :state,
      coerce: LightState

    property :name,
      coerce: String

    property :type,
      coerce: String

    property :modelid,
      coerce: String

    property :swversion,
      coerce: String

    property :manufacturername,
      coerce: String

    property :uniqueid,
      coerce: String

    property :pointsymbol,
      coerce: Hashie::Mash

    property :client,
      coerce: Hue::Client

    def turn_on
      change_state(on: true, transitiontime: 2, bri: 254)
    end

    def turn_off
      change_state(on: false, transitiontime: 2)
    end

    def change_state(options={})
      client.send(:simple_put, "lights/#{id}/state", options)
    end
  end
end
