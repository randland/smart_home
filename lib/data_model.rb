class DataModel < Hashie::Dash
  include Hashie::Extensions::Dash::Coercion

  private

  def self.class_property(name, default_class:nil, **options)
    params = options.merge(coerce: ->(val) { coerce_class val })
    property name.to_sym, params

    define_method(name) do
      send(:[], name) || default_class
    end
  end

  def self.truthy_property(name, default:false, **options)
    params = options.merge required: true,
      default: default,
      coerce: ->(val) { is_truthy? val }
    property name.to_sym, params

    define_method("#{name}?") do
      !!send(name)
    end
  end

  def self.tagged_property(name, coerce:, prototype:nil, **options)
    params = options.merge(coerce: ->(val) do
      coerce_objects val, to: coerce.values.first, via: coerce.keys.first
    end)
    params.merge! default: load_prototype(prototype) if prototype

    property name.to_sym, params
  end

  def self.coerce_class(val)
    val.try(:constantize) || val
  end

  def self.is_truthy?(val)
    case val
    when String then !!(val =~ /^(true|t|yes|y|1)$/i)
    when Numeric then !([-1,0].include? val.to_i)
    else val == true
    end
  end

  def self.coerce_objects(val, to: default_coerced_object, via: :tag)
    case val
    when Array then coerce_objects_from_array val, to: to, via: via
    when Hash then coerce_objects_from_hash val, to: to, via: via
    when String then coerce_objects_from_hash load_prototype(val), to: to, via: via
    else empty_coerced_object
    end
  end

  def self.default_coerced_object
    Hashie::Mash
  end

  def self.empty_coerced_object
    default_coerced_object.new
  end

  def self.coerce_objects_from_array(arr, to: default_coerced_object, via: :tag)
    arr.inject(empty_coerced_object) do |memo, obj|
      hash = case obj
             when Symbol then {via => obj}
             when String then {via => obj}
             else obj
             end
      memo.merge hash[via] => to.new(hash)
    end
  end

  def self.coerce_objects_from_hash(hash, to: default_coerced_object, via: :tag)
    hash.inject(empty_coerced_object) do |memo, (key, obj)|
      memo.merge key => to.new(obj.merge via => key)
    end
  end

  def self.load_prototype(filename)
    ::PrototypeLoader.load_prototype filename
  end
end

class PrototypeLoader
  BASE_PATH = File.expand_path("../../../config", __FILE__)

  @@loaded_prototypes = {}
  def self.load_prototype(filename)
    @@loaded_prototypes[filename] ||= YAML.load_file("#{BASE_PATH}/#{filename}.yml")
  end
end
