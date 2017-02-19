class Locator
  require 'json'
  GEOCODE_URL = 'https://maps.googleapis.com/maps/api/geocode'

  def initialize(location, options = {})
    data = options.fetch(:data) { get_data_from_api(location) }
    @location = location
    @navigation_data = validate_and_parse(data)
    @cache_class = options.fetch(:cache_class) { LocationCache }
  end

  def coordinates
    "#{geometry['location']['lat']},#{geometry['location']['lng']}"
  end

  def name
    navigation_data['formatted_address']
  end

  def write_to_cache
    @cache_class.write(location, attributes_for_cache)
  end

  private
  attr_reader :navigation_data, :location

  def attributes_for_cache
    {
      coordinates: coordinates,
      name: name
    }
  end

  def geometry
    navigation_data['geometry']
  end

  def get_data_from_api(location)
    `curl -s "#{GEOCODE_URL}/json?address=#{location}&key=#{ENV['GOOGLEMAPSSECRET']}"`
  end

  def validate_and_parse(data)
    response = JSON.parse(data)

    raise ArgumentError, "Location not found" if response['results'].empty?
    response['results'][0]
  end
end
