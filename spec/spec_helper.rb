ENV['RACK_ENV']         = 'test'
ENV['DARKSKYSECRET']    = 'fake secret'
ENV['GOOGLEMAPSECRET']  = 'fake secret'

require 'bundler'
Bundler.require

# require testing components
require 'rack/test'
require 'minitest/autorun'

# require application components
Dir.glob('./lib/**/*.rb') { |f| require f }
require 'json'

class BaseSpec < Minitest::Spec
  ENV['CACHE_PATH'] = File.expand_path('../fixtures/fake_cache.yml', __FILE__)

  def expand_path(path)
    File.expand_path(path, __FILE__)
  end

  class FakeForecaster
    attr_reader :coordinates, :units, :forecast_time
    def initialize(coordinates, units, forecast_time)
      @coordinates = coordinates
      @forecast_time = forecast_time
      @units = units
    end

    def method_missing(method, *args)
      method
    end
  end

  class FakeNavigator
    def initialize(location)
      @location = location
    end

    def coordinates
      "coordinates for #{@location}"
    end

    def location_name
      "formatted name of #{@location}"
    end
  end

  class FakeMoonInfo
    def initialize(moon_phase)
      @moon_phase = moon_phase
    end
  end

  class FakeLocator
    def initialize(location, options)
      raise ArgumentError, "Location not found" if location == 'unknown'
      @location = location
      @location_cache_class = options.fetch(:cache_class)
    end

    def coordinates
      "coordinates for #{@location}"
    end

    def name
      "formatted name of #{@location}"
    end

    def write_to_cache
      @location_cache_class.write(@location, {})
    end
  end

  class FakeLocationCache
    @@locations = []

    def self.write(location, attributes)
      @@locations.push(location)
    end

    def self.reset
      @@locations.clear
    end

    def initialize(location)
      @location = location
    end

    def exists?
      @@locations.include?(@location)
    end

    def coordinates
      "cached coordinates for #{@location}"
    end

    def name
      "cached formatted name of #{@location}"
    end
  end
end
