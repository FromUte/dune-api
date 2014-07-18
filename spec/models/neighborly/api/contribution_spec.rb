require 'spec_helper'

describe Neighborly::Api::Contribution do
  describe '.between_values' do
    it 'returns the contributions with value between 15 and 20' do
      FactoryGirl.create(:contribution, value: 10)
      FactoryGirl.create(:contribution, value: 15)
      FactoryGirl.create(:contribution, value: 20)
      FactoryGirl.create(:contribution, value: 21)

      expect(described_class.between_values(15, 20).size).to eq 2
    end
  end
end
