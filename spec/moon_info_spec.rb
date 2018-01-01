require 'spec_helper'

class MoonInfoSpec < BaseSpec
  let(:cycle_completion) { nil }
  let(:moon) { MoonInfo.new(cycle_completion) }

  # This service is built for the 'moonPhase' variable in the DarkSky API
  # where a 'new' moon is 0 (0.99, 0, and 0.01)
  # and a 'full' moon is 0.5 (0.49 - 0.51)

  describe 'new' do
    let(:cycle_completion) { 0 }

    it 'returns information about the current moon phase' do
      assert_equal 0, moon.illumination
      assert_equal 'new', moon.phase_name
      assert_equal false, moon.waxing?
      assert_equal false, moon.waning?
      #assert_equal ['water'], moon.active_elements
      assert_equal '🌑', moon.emoji
    end
  end

  describe 'waxing' do
    describe 'crescent' do
      let(:cycle_completion) { 0.02 }

      it 'returns information about the current moon phase' do
        assert_equal 0.03, moon.illumination
        assert_equal 'crescent', moon.phase_name
        assert_equal true, moon.waxing?
        assert_equal false, moon.waning?
        #assert_equal ['water', 'earth'], moon.active_elements
        assert_equal '🌒', moon.emoji
      end
    end

    describe 'first quarter' do
      let(:cycle_completion) { 0.25 }

      it 'returns information about the current moon phase' do
        assert_equal 0.51, moon.illumination
        assert_equal 'first quarter', moon.phase_name
        assert_equal true, moon.waxing?
        assert_equal false, moon.waning?
        #assert_equal ['earth'], moon.active_elements
        assert_equal '🌓', moon.emoji
      end
    end

    describe 'gibbous' do
      let(:cycle_completion) { 0.48 }

      it 'returns information about the current moon phase' do
        assert_equal 0.99, moon.illumination
        assert_equal 'gibbous', moon.phase_name
        assert_equal true, moon.waxing?
        assert_equal false, moon.waning?
        #assert_equal ['earth', 'fire'], moon.active_elements
        assert_equal '🌔', moon.emoji
      end
    end
  end

  describe 'full' do
    let(:cycle_completion) { 0.49 }

    it 'returns information about the current moon phase' do
      assert_equal 1, moon.illumination
      assert_equal 'full', moon.phase_name
      assert_equal false, moon.waxing?
      assert_equal false, moon.waning?
      #assert_equal ['fire'], moon.active_elements
      assert_equal '🌕', moon.emoji
    end
  end

  describe 'waning' do
    describe 'disseminating' do
      let(:cycle_completion) { 0.52 }

      it 'returns information about the current moon phase' do
        assert_equal 0.98, moon.illumination
        assert_equal 'disseminating', moon.phase_name
        assert_equal false, moon.waxing?
        assert_equal true, moon.waning?
        #assert_equal ['fire', 'air'], moon.active_elements
        assert_equal '🌖', moon.emoji
      end
    end

    describe 'last quarter' do
      let(:cycle_completion) { 0.75 }

      it 'returns information about the current moon phase' do
        assert_equal 0.5, moon.illumination
        assert_equal 'last quarter', moon.phase_name
        assert_equal false, moon.waxing?
        assert_equal true, moon.waning?
        #assert_equal ['air'], moon.active_elements
        assert_equal '🌗', moon.emoji
      end
    end

    describe 'balsamic' do
      let(:cycle_completion) { 0.98 }

      it 'returns information about the current moon phase' do
        assert_equal 0.02, moon.illumination
        assert_equal 'balsamic', moon.phase_name
        assert_equal false, moon.waxing?
        assert_equal true, moon.waning?
        #assert_equal ['air', 'water'], moon.active_elements
        assert_equal '🌘', moon.emoji
      end
    end
  end
end
