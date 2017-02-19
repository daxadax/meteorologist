class LocationCache
  require 'yaml'

  def self.write(location, attributes)
    new(location).write(attributes)
  end

  def initialize(location, options = {})
    @location = location.downcase
  end

  def exists?
    !cache[location].nil?
  end

  def coordinates
    cache[location][:coordinates] if exists?
  end

  def name
    cache[location][:name] if exists?
  end

  def write(attributes)
    validate_required_attributes(attributes)

    cache[location] = attributes
    File.open(cache_full_path, 'w+') { |f| f.write(cache.to_yaml) }
  end

  private
  attr_reader :location

  def cache
    return @cache if defined? @cache
    @cache = YAML.load(cache_contents) || Hash.new
  end

  def cache_contents
    File.read(cache_full_path)
  end

  def cache_full_path
    File.expand_path(ENV['CACHE_PATH'], __FILE__)
  end

  def validate_required_attributes(attributes)
    invalid_attributes unless attributes[:coordinates]
    invalid_attributes unless attributes[:name]
  end

  def invalid_attributes
    raise ArgumentError, 'You must include location name and coordinates'
  end
end
