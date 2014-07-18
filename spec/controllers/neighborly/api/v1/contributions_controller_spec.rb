require 'spec_helper'

describe Neighborly::Api::V1::ContributionsController do
  routes { Neighborly::Api::Engine.routes }

  let(:contributions_returned) do
    parsed_response.fetch('contributions').map { |t| t['id'] }
  end
  let(:parsed_response) { JSON.parse(response.body) }

  describe '#index', authorized: true do
    let!(:contribution)   { FactoryGirl.create(:contribution) }
    let(:do_request) { get :index, format: :json }

    it_behaves_like 'paginating results'

    describe 'filter by state' do
      let!(:pending_contribution) do
        FactoryGirl.create(:contribution, state: :pending)
      end

      Contribution.state_names.each do |state|
        it "filters by state #{state}" do
          contribution      = FactoryGirl.create(:contribution, state: state)
          expected_ids = if state.eql?(:pending)
            [contribution.id, pending_contribution.id]
          else
            [contribution.id]
          end

          get :index, format: :json, state => '1'
          expect(contributions_returned).to include(*expected_ids)
        end
      end
    end
  end
end
