require 'spec_helper'

describe Dune::Api::V1::InvestmentsController do
  routes { Dune::Api::Engine.routes }
  let!(:investment) { FactoryGirl.create(:investment) }

  let(:investments_returned) do
    parsed_response.fetch('investments').map { |t| t['id'] }
  end

  let(:parsed_response) { JSON.parse(response.body) }

  describe '#index', authorized: true, admin: true do
    let(:do_request) { get :index, format: :json }

    it_behaves_like 'paginating results'

    it 'filters by query' do
      investment = FactoryGirl.create(:investment, payment_method: 'balanced')
      FactoryGirl.create(:investment, payment_method: 'paypal')
      get :index, format: :json, query: 'balanced'
      expect(investments_returned).to eql([investment.id])
    end

    describe 'filtering by between_values' do
      before do
        @investment_30 = FactoryGirl.create(:investment, value: 30)
        @investment_35 = FactoryGirl.create(:investment, value: 35)
        FactoryGirl.create(:investment, value: 40)
      end

      it 'returns just those investments in the given range' do
        get :index, format: :json,
          between_values: {
            initial: 30,
            final:   35
          }
        expect(investments_returned).to eql([@investment_35.id, @investment_30.id])
      end
    end

    describe 'filter by state' do
      let!(:pending_investment) do
        FactoryGirl.create(:investment, state: :pending)
      end

      Investment.state_names.each do |state|
        it "filters by state #{state}" do
          investment = FactoryGirl.create(:investment, state: state)
          expected_ids = if state.eql?(:pending)
            [investment.id, pending_investment.id]
          else
            [investment.id]
          end

          get :index, format: :json, state => '1'
          expect(investments_returned).to include(*expected_ids)
        end
      end
    end

    describe 'filter by project id' do
      let(:first_project)  { FactoryGirl.create(:project, state: 'online') }
      let(:second_project) { FactoryGirl.create(:project, state: 'online') }

      before do
        @investment = FactoryGirl.create(:investment, value: 10, project: first_project)
        FactoryGirl.create(:investment, value: 10, project: second_project)
      end

      it 'returns just those investments in the given project id' do
        get :index, project_id: first_project.id, format: :json
        expect(investments_returned).to eql([@investment.id])
      end
    end
  end

  describe '#show', authorized: true, admin: true do
    let(:do_request) { get :show, id: investment.id, format: :json }

    it 'responds with 200' do
      do_request
      expect(response.status).to eql(200)
    end

    it 'has a top level element called investment' do
      do_request
      expect(parsed_response.fetch('investment')).to be_a(Hash)
    end

    it 'responds with data of the given investment' do
      do_request
      expect(
        parsed_response.fetch('investment')
      ).to have_key('id')
    end
  end

  describe '#update', authorized: true, admin: true do
    let(:do_request) do
      put :update,
          id: investment.id,
          investment: { value: 15 },
          format: :json
    end

    it 'updates the record' do
      expect(::Investment).to receive(:update)
        .with(investment.id.to_s, { 'value' => 15 })

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
            id: investment.id,
            investment: { value: nil },
            format: :json
      end

      it 'returns a unprocessable entity http status' do
        do_request
        expect(response.status).to eq(422)
      end

      it 'returns a json with errors' do
        do_request

        expect(parsed_response.count).to eq(1)
        expect(parsed_response['errors']['value']).not_to be_empty
      end
    end
  end

  describe 'destroy', authorized: true, admin: true do
    let(:do_request) { delete :destroy, id: investment.id, format: :json }

    it 'returns a success http status' do
      do_request
      expect(response.status).to eq(204)
      expect(investment.reload.deleted?).to be_truthy
    end
  end

  [:confirm, :pendent, :refund, :hide, :cancel].each do |name|
    describe "#{name}", authorized: true, admin: true do
      let(:user)         { FactoryGirl.create(:user, admin: true) }
      let(:investment) do
        state = (name == :refund) ? 'confirmed' : 'deleted'
        FactoryGirl.create(:investment, state: state)
      end
      let(:do_request)   { put name, id: investment.id, format: :json }

      it 'returns a success http status' do
        do_request
        expect(response.status).to eq(204)
      end

      it 'authorizes the resource' do
        expect(controller).to receive(:authorize).with(investment)
        do_request
      end

      it 'calls the state machine helper to change the state' do
        expect_any_instance_of(Investment).to receive("#{name}!")
        do_request
      end
    end
  end
end
