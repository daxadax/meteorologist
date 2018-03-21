Dir.glob(File.expand_path('meteorologist/*.rb', __FILE__)) { |f| require f }

class Meteorologist
  def initialize(location, options = {})
    validate_environment

    @location = location
    @forecaster_class = options.fetch(:forecaster) { ::Forecaster }
    @navigator_class = options.fetch(:navigator) { ::Navigator }
    @moon_info_class = options.fetch(:moon_info) { ::MoonInfo }
    @forecast_time = options.fetch(:forecast_time) { Time.now }
    @units = options.fetch(:units) { 'si' } # or 'us' for Imperial units
  end

  def forecast
    @forecast ||= @forecaster_class.new(coordinates, units, forecast_time)
  end

  def moon
    @moon ||= @moon_info_class.new(forecast.moon_phase)
  end

  def location_name
    navigator.location_name
  end

  private
  attr_reader :location, :forecast_time, :units

  def coordinates
    navigator.coordinates
  end

  def navigator
    @navigator ||= @navigator_class.new(location)
  end

  def validate_environment
    p "WARNING: You have not set a cache path" unless ENV['CACHE_PATH']
    raise RuntimeError, "You must set a Darksky API secret" unless ENV['DARKSKYSECRET']
    raise RuntimeError, "You must set a Google API secret" unless ENV['GOOGLEMAPSECRET']
  end
end
