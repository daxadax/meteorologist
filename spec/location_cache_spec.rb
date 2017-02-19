require_relative 'spec_helper'

class LocationCacheSpec < BaseSpec
  let(:cache_path) { ENV['CACHE_PATH'] }
  let(:result) { LocationCache.new(forecast_location) }

  after { File.truncate(cache_path, 0) }

  describe 'writing to the cache' do
    let(:forecast_location) { 'Fnordsburg' }
    let(:attributes) do
      {
        coordinates: '23,23',
        name: 'Fnordsburg, USA'
      }
    end
    it 'validates the presence of coordinates and name' do
      assert_raises { result.write({}) }
      assert_raises { result.write({coordinates: '23,23'}) }
      assert_raises { result.write({name: 'Fnordsburg, USA'}) }
    end

    it 'writes correctly formatted requests into the cache' do
      result.write(attributes)
      result_after_write = LocationCache.new(forecast_location)

      assert_equal true, result_after_write.exists?
      assert_equal '23,23', result_after_write.coordinates
      assert_equal 'Fnordsburg, USA', result_after_write.name
    end
  end

  describe 'when the location cannot be found' do
    let(:forecast_location) { 'unknown' }

    it 'returns queries to #exists? as false' do
      assert_equal false, result.exists?
    end

    it 'does not return location attributes' do
      assert_nil result.coordinates
      assert_nil result.name
    end
  end

  describe 'when the location can be found' do
    before do
      File.open(cache_path, 'w+') { |f| f.write(attributes.to_yaml) }
    end

    let(:forecast_location) { 'queens' }
    let(:attributes) do
      {
        forecast_location => {
          coordinates: '40.7282239,-73.7948516',
          name: 'Queens, NY, USA'
        }
      }
    end

    it 'returns queries to #exists? as true' do
      assert_equal true, result.exists?
    end

    it 'returns location attributes' do
      assert_equal '40.7282239,-73.7948516', result.coordinates
      assert_equal 'Queens, NY, USA', result.name
    end
  end
end
