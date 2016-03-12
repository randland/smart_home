module Hue
  class Group < DataModel
    property :id,
      coerce: String
    
    property :client,
      coerce: Hue::Client

    property :name,
      coerce: String

    property :lights,
      coerce: Array[String]

    property :type,
      coerce: String

    property :class_name,
      coerce: String

    property :action,
      coerce: GroupState

    def turn_on
      change_state(on: true, transitiontime: 2, bri: 254)
    end

    def turn_off
      change_state(on: false, transitiontime: 2)
    end

    def change_state(options={})
      client.send(:simple_put, "groups/#{id}/action", options)
    end
  end
end
