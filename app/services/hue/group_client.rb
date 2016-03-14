module Hue
  class GroupClient < BaseClient
    class << self
      def groups
        get
      end

      def group(id)
        get(id)
      end

      def create_group(*lights, **params)
        post(params)
      end

      def update_group(id, **params)
        put(id, params)
      end

      def update_group_state(id, **params)
        put(id, 'action', params)
      end

      def delete_group(id)
        delete(id)
      end

      private

      def uri_prefix
        "/groups"
      end
    end
  end
end

