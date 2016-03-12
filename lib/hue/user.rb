module Hue
  class User
    attr_reader :username

    def initialize(options={})
      @client = options.fetch(:client)
      @username = options[:bridge_username]
      get_user_info
    end

    private

    def get_user_info
      params = {
        body: {
          'devicetype' => 'smart_home#client'
        }.to_json
      }

      @username ||= nil

      while @username.nil?
        result = @client.class.post('/', params).body
        @username = JSON.parse(result).first.fetch('success', {})['username']
        sleep(10) unless @username.present?
      end
    end
  end
end
