require_relative 'spec_helper'

class MeteorologistSpec < BaseSpec
  let(:options) do
    {
      forecaster: FakeForecaster,
      navigator: FakeNavigator
    }
  end
  let(:result) { Meteorologist.new(forecast_location, options) }
  let(:forecast_location) { 'some location' }

  it 'returns an instance of Forecaster when forecast is called' do
    assert_kind_of FakeForecaster, result.forecast
  end

  it 'defaults units to standard imperial' do
    assert_equal 'si', result.forecast.units
  end

  it 'uses coordinates returned by the navigator' do
    assert_equal "coordinates for #{forecast_location}", result.forecast.coordinates
  end

  it 'uses a location name returned by the navigator' do
    assert_equal "formatted name of #{forecast_location}", result.location_name
  end
end
