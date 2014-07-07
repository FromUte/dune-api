require 'spec_helper'

describe Neighborly::Api::V1::ProjectsController do
  routes { Neighborly::Api::Engine.routes }
  let(:projects_returned) do
    parsed_response.fetch('projects').map { |t| t['id'] }
  end
  let(:parsed_response) { JSON.parse(response.body) }

  describe '#index', authorized: true do
    let(:do_request) { get :index, format: :json }

    it_behaves_like 'paginating results'

    describe 'filter by state' do
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
          expect(projects_returned).to include(*expected_ids)
        end
      end
    end

    describe 'filter by category_id' do
      let!(:project) { FactoryGirl.create(:project) }
      let!(:project_with_given_category) { FactoryGirl.create(:project) }
      let(:category) { project_with_given_category.category }

      it 'shows just projects in the scope when receiving parameter' do
        get :index, format: :json, by_category_id: category.id
        expect(projects_returned).to eql([project_with_given_category.id])
      end

      it 'returns all possible projects when category_id is not present' do
        get :index, format: :json
        expect(projects_returned).to eql(Project.pluck(:id))
      end
    end

    describe 'ordering' do
      let!(:project_1) { FactoryGirl.create(:project, name: 'abc') }
      let!(:project_2) { FactoryGirl.create(:project, name: 'xyz') }

      it 'order by given attribute' do
        get :index, format: :json, order_by: 'name desc'
        expected_projects = [
          project_2.id,
          project_1.id
        ]
        expect(projects_returned).to eql(expected_projects)
      end
    end
  end
end
