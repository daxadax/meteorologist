class Forecaster
  require 'json'
  DARKSKY_URL = "https://api.darksky.net/forecast"

  def initialize(coordinates, units, forecast_time, options = {})
    data = options.fetch(:data) { get_data(coordinates, units, forecast_time) }
    @forecast = validate_and_parse(data)
  end

  def current_summary
    current('summary')
  end

  def current_temperature
    current('temperature')
  end

  def current_apparent_temperature
    current('apparentTemperature')
  end

  def current_humidity
    "#{(current('humidity') * 100).to_i}%"
  end

  def todays_summary
    todays('summary')
  end

  def sunrise
    get_time(todays('sunriseTime'))
  end

  def sunset
    get_time(todays('sunsetTime'))
  end

  def moon_phase
    todays('moonPhase')
  end

  def minimum_temperature
    todays('temperatureMin')
  end

  def apparent_minimum_temperature
    todays('apparentTemperatureMin')
  end

  def maximum_temperature
    todays('temperatureMax')
  end

  def apparent_maximum_temperature
    todays('apparentTemperatureMax')
  end

  private
  attr_reader :forecast

  def get_data(coordinates, units, forecast_time)
    time = forecast_time.to_i
    url = "#{DARKSKY_URL}/#{ENV['DARKSKYSECRET']}/#{coordinates},#{time}?units=#{units}"

    `curl -s #{url}`
  end

  def validate_and_parse(forecast)
    response = JSON.parse(forecast)

    raise ArgumentError, "Location not found" if response['error']
    response
  end

  def current(key)
    forecast['currently'][key]
  end

  def todays(key)
    forecast['daily']['data'][0][key]
  end

  def get_time(integer)
    (Time.at(integer) + offset).strftime('%H:%M')
  end

  def offset
    @offset ||= forecast['offset'].to_i * 3600
  end
end
