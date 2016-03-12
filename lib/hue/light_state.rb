module Hue
  class LightState < DataModel
    truthy_property :on

    property :bri,
      coerce: Integer

    property :hue,
      coerce: Integer

    property :sat,
      coerce: Integer

    property :xy,
      coerce: Array[Float]

    property :ct,
      coerce: Integer

    property :alert,
      coerce: Symbol

    property :effect,
      coerce: Symbol

    property :colormode,
      coerce: Symbol

    truthy_property :reachable
  end
end
