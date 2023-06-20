require 'spec_helper'

class MoonSignCalculatorSpec < BaseSpec
  subject { MoonSign.new(sky_time) }

  describe 'with an invalid date' do

  end

  describe 'with a valid date' do
    describe '1 January 2018, 18h, GMT + 1' do
      let(:sky_time) { Time.new(2018,1,1,18,0,0,1) }

      it 'returns Cancer' do 
        assert_equal 'Cancer', subject.sign
        assert_equal '♋', subject.symbol
        assert_in_delta 5, subject.degree, 1 # expected, actual, delta
      end
    end

    describe '9 June 1905, 03:18, GMT - 5' do
      let(:sky_time) { Time.new(1905,6,9,3,18,0,-5) }

      it 'returns Virgo' do 
        assert_equal 'Virgo', subject.sign
        assert_equal '♍', subject.symbol
        assert_in_delta 2, subject.degree, 1 # expected, actual, delta
      end
    end

    describe '21 December 2012, 12:21, GMT' do
      let(:sky_time) { Time.new(2012,12,21,12,21,0,0) }

      it 'returns Aries' do 
        assert_equal 'Aries', subject.sign
        assert_equal '♈', subject.symbol
        assert_in_delta 14, subject.degree, 1 # expected, actual, delta
      end
    end
  end
end
