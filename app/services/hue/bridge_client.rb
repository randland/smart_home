module Hue
  class BridgeClient < BaseClient
    class << self
      def username
        @username ||= cached_username || request_username
      end

      def full_status
        get
      end

      private

      def cached_username
        ENV['HUE_USERNAME']
      end

      def request_username
        fails = 0

        begin
          result = post(devicetype: 'SmartHome').first['success']

          unless result
            puts 'Please press the link button on the Hue hub'
            sleep(1)
            fails += 1
          end

        end until result || fails >= 15

        raise 'Unable to connect to the Hue bridge' unless result

        result['username']
      end
    end
  end
end

