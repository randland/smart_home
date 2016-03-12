module Hue
  class Client
    include HTTParty

    DEFAULT_BRIDGE_IP = '192.168.1.150'
    DEFAULT_BRIDGE_USERNAME = 'babb76027a034f5fdc3b02797833f'

    attr_reader :lights, :groups

    def initialize(options={})
      options
        .merge!(
          client: self
        )
        .reverse_merge!(
          bridge_ip: DEFAULT_BRIDGE_IP,
          bridge_username: DEFAULT_BRIDGE_USERNAME
        )

      @bridge = Hue::Bridge.new(options)
      self.class.base_uri("http://#{@bridge.ip}/api")

      @user = Hue::User.new(options)

      @lights = get_lights

      @lights.keys.each do |key|
        light_data = @lights[key].symbolize_keys
        light_data[:id] = key
        light_data[:client] = self
        light_data[:state].symbolize_keys!
        @lights[key] = Light.new(light_data)
      end

      @groups = get_groups

      @groups.keys.each do |key|
        group_data = @groups[key].symbolize_keys
        group_data[:id] = key
        group_data[:client] = self
        group_data[:action].symbolize_keys!
        group_data[:class_name] = group_data.delete(:class)
        @groups[key] = Group.new(group_data)
      end
    end

    def get_lights
      simple_get('lights')
    end

    def get_groups
      simple_get('groups')
    end

    def add_group(name:, lights:[])
      simple_post 'groups',
        name: name,
        type: 'LightGroup',
        lights: lights.map(&:to_s)
    end

    def add_room(name:, class_name:, lights:[])
      simple_post 'groups',
        name: name,
        type: 'Room',
        class: class_name.to_s.humanize,
        lights: lights.map(&:to_s)
    end

    private

    def simple_get(path="/")
      JSON.parse(self.class.get("/#{username}/#{path}").body)
    end

    def simple_post(path="/", params={})
      JSON.parse(self.class.post("/#{username}/#{path}", body: params.to_json).body)
    end

    def simple_put(path="/", params={})
      JSON.parse(self.class.put("/#{username}/#{path}", body: params.to_json).body)
    end

    def username
      @user.username
    end

  end
end
