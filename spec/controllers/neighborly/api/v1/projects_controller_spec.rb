require 'spec_helper'

describe Neighborly::Api::V1::ProjectsController do
  routes { Neighborly::Api::Engine.routes }
  let(:parsed_response) { JSON.parse(response.body) }

  describe '#index', authorized: true do
    let(:do_request) { get :index, format: :json }

    it 'returns a json' do
      do_request
      #, {}, { 'Accept' => 'application/vnd.neighbor.ly; version=1' }
      json = JSON.parse(response.body)

      expect(json.fetch('projects').count).to eq(0)
    end
  end

  describe '#update', authorized: true do
    let(:project) { FactoryGirl.create(:project, user: user) }

    let(:do_request) do
      put :update,
          id: project.id,
          project: { name: 'Foo Bar Updated' },
          format: :json
    end

    context 'when user has access to the project' do
      it 'updates the record' do
        expect(Project).to receive(:update)
          .with(project.id.to_s, { "name" => 'Foo Bar Updated' })

        do_request
      end

      context 'on success' do
        it 'returns a no content http status' do
          do_request
          expect(response.status).to eq(204)
        end
      end

      context 'on failure' do
        let(:do_request) do
          put :update,
              id: project.id,
              project: { name: '' },
              format: :json
        end

        it 'returns a unprocessable entity http status' do
          do_request
          expect(response.status).to eq(422)
        end

        it 'returns a json with errors' do
          do_request

          expect(parsed_response.count).to eq(1)
          expect(parsed_response['errors']['name']).not_to be_empty
        end
      end
    end

    context 'when user does not have access to the project' do
      let(:project) { FactoryGirl.create(:project) }

      it 'does not update the record' do
        expect(Project).not_to receive(:update)
        do_request
      end

      it 'returns a forbidden http status' do
        do_request
        expect(response.status).to eq(403)
        expect(project.reload.deleted?).to be_falsy
      end
    end
  end

  describe 'destroy', authorized: true do
    let(:project)    { FactoryGirl.create(:project, user: user) }
    let(:do_request) { delete :destroy, id: project.id, format: :json }

    context 'when it can be pushed to trash' do
      it 'returns a success http status' do
        do_request
        expect(response.status).to eq(204)
        expect(project.reload.deleted?).to be_truthy
      end
    end

    context 'when it cannot be pushed to trash' do
      let(:project) { FactoryGirl.create(:project, user: user, state: :online) }

      it 'returns a forbidden http status' do
        do_request
        expect(response.status).to eq(403)
        expect(project.reload.deleted?).to be_falsy
      end
    end
  end

  [:approve, :launch, :reject, :push_to_draft].each do |name|
    describe "#{name}", authorized: true do
      let(:user)       { FactoryGirl.create(:user, admin: true) }
      let(:project)    { FactoryGirl.create(:project) }
      let(:do_request) { put name, id: project.id, format: :json }

      it 'returns a success http status' do
        do_request
        expect(response.status).to eq(204)
      end

      it 'authorizes the resource' do
        expect(controller).to receive(:authorize).with(project)
        do_request
      end

      it 'calls the state machine helper to change the state' do
        expect_any_instance_of(Project).to receive("#{name}!")
        do_request
      end
    end
  end
end
