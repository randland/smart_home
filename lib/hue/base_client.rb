module Hue
  class BaseClient
    class << self
      private

      %W(delete get head options post put).each do |verb|
        define_method(verb) do |*path, **params|
          client.send(verb, uri_path(*path), params)
        end
      end

      def uri_prefix
        '/'
      end

      def uri_path(*uri_components)
        ([uri_prefix] + uri_components).flatten.join("/")
      end

      def client
        Hue::APIClient
      end
    end
  end
end

