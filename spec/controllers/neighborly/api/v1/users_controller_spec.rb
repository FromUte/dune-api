require 'spec_helper'

describe Neighborly::Api::V1::UsersController do
  routes                { Neighborly::Api::Engine.routes }
  let(:parsed_response) { JSON.parse(response.body) }

  describe '#show', authorized: true do
    let(:do_request) { get :show, id: user.id, format: :json }

    it 'responds with 200' do
      do_request
      expect(response.status).to eql(200)
    end

    it 'has a top level element called user' do
      do_request
      expect(parsed_response.fetch('user')).to be_a(Hash)
    end

    it 'responds with data of the given user' do
      do_request
      expect(
        parsed_response.fetch('user')
      ).to have_key('id')
    end
  end
end
