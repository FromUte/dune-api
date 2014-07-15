require 'spec_helper'

describe Neighborly::Api::V1::ChannelsController do
  routes                { Neighborly::Api::Engine.routes }
  let(:parsed_response) { JSON.parse(response.body) }
  let!(:channel)        { FactoryGirl.create(:channel) }

  describe '#show', authorized: true do
    let(:do_request) { get :show, id: channel.id, format: :json }

    it 'responds with 200' do
      do_request
      expect(response.status).to eql(200)
    end

    it 'has a top level element called channel' do
      do_request
      expect(parsed_response.fetch('channel')).to be_a(Hash)
    end

    it 'responds with data of the given channel' do
      do_request
      expect(
        parsed_response.fetch('channel')
      ).to have_key('id')
    end
  end
end
