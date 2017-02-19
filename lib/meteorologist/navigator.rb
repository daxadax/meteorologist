class Navigator
  def initialize(location, options = {})
    @location = location
    @location_cache_class = options.fetch(:location_cache) { LocationCache }
    @locator_class = options.fetch(:locator) { Locator }
    fetch_cache_values
  end

  def coordinates
    @coordinates ||= locator.coordinates
  end

  def location_name
    @location_name ||= locator.name
  end

  private
  attr_reader :location

  def fetch_cache_values
    #todo more elegant solution for when cache is not set?
    return unless ENV['CACHE_PATH']

    if cached_location.exists?
      @coordinates = cached_location.coordinates
      @location_name = cached_location.name
    else
      locator.write_to_cache
    end
  end

  def locator
    @locator ||= @locator_class.new(location, cache_class: @location_cache_class)
  end

  def cached_location
    @cached_location ||= @location_cache_class.new(location)
  end
end
