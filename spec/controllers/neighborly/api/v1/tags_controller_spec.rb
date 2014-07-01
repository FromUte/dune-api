require 'spec_helper'

describe Neighborly::Api::V1::TagsController do
  routes { Neighborly::Api::Engine.routes }
  let(:parsed_response) { JSON.parse(response.body) }

  describe '#create', authorized: true, admin: true do
    let(:do_request) { post :create, tag: { name: 'foobar', visible: true } , format: :json }

    context 'on success' do
      it 'returns a created http status' do
        do_request
        expect(response.status).to eq(201)
      end

      it 'returns a json' do
        do_request

        expect(parsed_response.count).to eq(1)
        expect(parsed_response['tag']['name']).to eq('foobar')
        expect(parsed_response['tag']['visible']).to eq(true)
      end
    end

    context 'on failure' do
      let(:do_request) { post :create, tag: { } , format: :json }

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
end
