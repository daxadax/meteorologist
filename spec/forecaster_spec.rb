require_relative 'spec_helper'

class ForecasterSpec < BaseSpec
  let(:coordinates) { '23,666' }
  let(:units) { 'si' }
  let(:options) do
    { data: data }
  end
  let(:forecast) { Forecaster.new(coordinates, units, options) }

  describe 'when the location is found' do
    let(:forecast_location) { 'queens' }
    let(:data) { fixture_data(forecast_location) }

    it 'gets darksky forecast data for the given location' do
      assert_equal 'Clear', forecast.current_summary
      assert_equal 5.78,    forecast.current_temperature
      assert_equal 2.78,    forecast.current_apparent_temperature
      assert_equal '42%',   forecast.current_humidity

      assert_equal('Mostly cloudy starting in the evening.', forecast.todays_summary)
      assert_equal(0.53, forecast.moon_phase)
      assert_equal(-0.25,       forecast.minimum_temperature)
      assert_equal(-4.63,       forecast.apparent_minimum_temperature)
      assert_equal(6.13,        forecast.maximum_temperature)
      assert_equal(3.31,        forecast.apparent_maximum_temperature)
    end

    it 'adjusts times from GMT to the location\'s timezone' do
      assert_equal('08:13', forecast.sunrise)
      assert_equal('17:29', forecast.sunset)
    end
  end

  describe 'when the location is not found' do
    let(:forecast_location) { 'unknown' }
    let(:data) { fixture_data(forecast_location) }

    it 'returns an error' do
      exception = assert_raises(ArgumentError) { forecast }
      assert_equal 'Location not found', exception.message
    end
  end

  def fixture_data(location)
    path = expand_path("../fixtures/darksky_api_#{location}.json")
    File.read(path)
  end
end
