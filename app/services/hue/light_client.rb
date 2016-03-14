module Hue
  class LightClient < BaseClient
    class << self
      def lights
        get
      end

      def light(id)
        get(id)
      end

      def new_lights
        get('new')
      end

      def search_for_new_lights(*serial_numbers)
        post(deviceid: serial_numbers.first(10))
      end

      def update_light(id, name)
        put(id, name: name)
      end

      def update_light_state(id, state={})
        put(id, 'state', state)
      end

      def delete_light(id)
        delete(id)
      end

      private

      def uri_prefix
        "/lights"
      end
    end
  end
end

