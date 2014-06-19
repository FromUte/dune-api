require 'spec_helper'

describe Neighborly::Api::V1::ProjectsController do
  routes { Neighborly::Api::Engine.routes }

  describe '#index' do
    it 'returns a json' do
      get :index, format: :json
      #, {}, { 'Accept' => 'application/vnd.neighbor.ly; version=1' }
      json = JSON.parse(response.body)

      expect(json.count).to eq(0)
    end
  end
end
