require 'spec_helper'

describe Neighborly::Api::V1::ProjectsController do
  routes { Neighborly::Api::Engine.routes }

  describe '#index', authorized: true do
    let(:do_request)      { get :index, format: :json }
    let(:parsed_response) { JSON.parse(response.body) }

    it 'returns a json' do
      do_request
      #, {}, { 'Accept' => 'application/vnd.neighbor.ly; version=1' }
      json = JSON.parse(response.body)

      expect(json.fetch('projects').count).to eq(0)
    end

    it_behaves_like 'paginating results'

    describe 'states' do
      let!(:draft_project) { FactoryGirl.create(:project, state: :draft) }

      Project.state_names.each do |state|
        it "filters by state #{state}" do
          project      = FactoryGirl.create(:project, state: state)
          expected_ids = if state.eql?(:draft)
            [project.id, draft_project.id]
          else
            [project.id]
          end

          get :index, format: :json, state => '1'
          expect(
            parsed_response.fetch('projects').map { |p| p['id'] }
          ).to include(*expected_ids)
        end
      end
    end
  end
end
