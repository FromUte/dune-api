require 'spec_helper'

describe Neighborly::Api::V1::ProjectsController do
  include ActiveSupport::Testing::TimeHelpers
  routes { Neighborly::Api::Engine.routes }
  let(:projects_returned) do
    parsed_response.fetch('projects').map { |t| t['id'] }
  end
  let(:parsed_response) { JSON.parse(response.body) }

  describe '#index', authorized: true do
    let(:do_request) { get :index, format: :json }

    it_behaves_like 'paginating results'

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
      before { FactoryGirl.create(:project) }
      let!(:project) { FactoryGirl.create(:project) }
      let(:category) { project.category }

      it 'shows just projects in the scope when receiving parameter' do
        get :index, format: :json, by_category_id: category.id
        expect(projects_returned).to eql([project.id])
      end

      it 'returns all possible projects when category_id is not present' do
        get :index, format: :json
        expect(projects_returned).to eql(Project.pluck(:id))
      end
    end

    describe 'filtering by created_at' do
      before do
        travel_to(10.days.ago) do
          FactoryGirl.create(:project)
        end
      end

      it 'returns just those projects in the given range' do
        project = travel_to(3.days.ago) do
          FactoryGirl.create(:project)
        end
        get :index, format: :json,
          between_created_at: {
            starts_at: 6.days.ago.to_date.to_s,
            ends_at:   Time.now.to_date.to_s
          }
        expect(projects_returned).to eql([project.id])
      end
    end

    describe 'filtering by expires_at' do
      before do
        travel_to(10.days.ago) do
          FactoryGirl.create(:project, online_date: Date.current, online_days: 1)
        end
      end

      it 'returns just those projects in the given range' do
        project = travel_to(3.days.ago) do
          FactoryGirl.create(:project, online_date: Date.current, online_days: 1)
        end
        get :index, format: :json,
          between_expires_at: {
            starts_at: 6.days.ago.to_date.to_s,
            ends_at:   Time.now.to_date.to_s
          }
        expect(projects_returned).to eql([project.id])
      end
    end

    describe 'filtering by online_date' do
      before do
        FactoryGirl.create(:project, online_date: 10.days.from_now)
      end

      it 'returns just those projects in the given range' do
        project = FactoryGirl.create(:project, online_date: 3.days.from_now)
        get :index, format: :json,
          between_online_date: {
            starts_at: Time.now.to_date.to_s,
            ends_at:   6.days.from_now.to_date.to_s
          }
        expect(projects_returned).to eql([project.id])
      end
    end
  end
end
