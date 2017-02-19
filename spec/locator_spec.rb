require_relative 'spec_helper'

class LocatorSpec < BaseSpec
  let(:result) { Locator.new(forecast_location, options) }
  let(:cache_class) { FakeLocationCache }
  let(:data) { fixture_data(forecast_location) }
  let(:options) do
    {
      cache_class: cache_class,
      data: data
    }
  end

  describe 'when the location cannot be found' do
    let(:forecast_location) { 'unknown' }

    it 'returns an error' do
      exception = assert_raises(ArgumentError) { result }
      assert_equal 'Location not found', exception.message
    end
  end

  describe 'when the location can be found' do
    before { FakeLocationCache.reset }
    let(:forecast_location) { 'queens' }

    it 'returns location attributes' do
      assert_equal '40.7282239,-73.7948516', result.coordinates
      assert_equal 'Queens, NY, USA', result.name
    end

    it 'can write the location into the provided cache' do
      assert_equal false, cache_class.new(forecast_location).exists?
      result.write_to_cache
      assert_equal true, cache_class.new(forecast_location).exists?
    end
  end

  def fixture_data(location)
    path = expand_path("../fixtures/geocode_api_#{location}.json")
    File.read(path)
  end
end
