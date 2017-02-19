require_relative 'spec_helper'

class NavigatorSpec < BaseSpec
  before { FakeLocationCache.reset }

  let(:navigator) { Navigator.new(forecast_location, options) }
  let(:forecast_location) { 'queens' }
  let(:options) do
    {
      locator: FakeLocator,
      location_cache: FakeLocationCache
    }
  end

  describe 'when the location has not been searched for previously' do
    it 'writes the location information into the location cache' do
      assert_equal false, FakeLocationCache.new(forecast_location).exists?
      navigator.coordinates
      assert_equal true, FakeLocationCache.new(forecast_location).exists?
    end

    it 'returns coordinates for the location' do
      assert_equal "coordinates for #{forecast_location}", navigator.coordinates
    end

    it 'returns a formatted name for the location' do
      assert_equal "formatted name of #{forecast_location}", navigator.location_name
    end
  end

  describe 'when the location has been searched for previously' do
    before { FakeLocationCache.write(forecast_location, {}) }

    it 'returns cached coordinates for the location' do
      expected = "cached coordinates for #{forecast_location}"
      assert_equal expected, navigator.coordinates
    end

    it 'returns a formatted name for the location' do
      expected = "cached formatted name of #{forecast_location}"
      assert_equal expected, navigator.location_name
    end
  end
end
