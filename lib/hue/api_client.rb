module Hue
  class APIClient
    class << self
      attr_accessor :ip, :username

      %W(delete get head options post push).each do |verb|
        define_method(verb) do |path, params={}|
          http_client.send(verb, build_uri(path), build_query(params)).parsed_response
        end
      end

      def base_uri
        uri = "http://#{@ip}/api"
        uri << "/#{@username}" if @username.present?
        uri
      end

      private

      def http_client
        HTTParty
      end

      def build_uri(path='')
        base_uri + path
      end

      def build_query(params={})
        { body: params.to_json }
      end
    end
  end
end

