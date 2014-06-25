require 'spec_helper'

describe Neighborly::Api::V1::SessionsController do
  routes                { Neighborly::Api::Engine.routes }
  let!(:user)           { FactoryGirl.create(:user) }
  let(:parsed_response) { JSON.parse(response.body) }

  describe '#create' do
    it 'responds with 401 when requested with invalid email/password combination' do
      post :create, email: user.email, password: 'wrong-password'
      expect(response.status).to eql(401)
    end

    it 'responds with 400 when requested with no email' do
      post :create, password: 'right-password'
      expect(response.status).to eql(400)
    end

    it 'responds with 400 when requested with no password' do
      post :create, email: user.email
      expect(response.status).to eql(400)
    end

    it 'responds with 201 when requested with valid email and password combination' do
      post :create, email: user.email, password: 'right-password'
      expect(response.status).to eql(201)
    end

    it 'returns session data when requested with valid email and password combination' do
      post :create, email: user.email, password: 'right-password'
      expect(parsed_response['access_token']).to eql(user.get_access_token)
      expect(parsed_response['user_id']).to      eql(user.id)
    end
  end

  describe '#destroy' do
    let(:valid_access_token) { FactoryGirl.create(:access_token, user: user) }

    context 'when access_token is provided' do
      context 'and is valid' do
        it 'responds with 200' do
          delete :destroy, access_token: valid_access_token.code
          expect(response.status).to eql(200)
        end

        it 'expires given access_token' do
          delete :destroy, access_token: valid_access_token.code
          expect(valid_access_token.reload).to be_expired
        end
      end

      context 'and is not valid' do
        it 'responds with 400 when inexistant' do
          delete :destroy, access_token: 'invalid-access-token'
          expect(response.status).to eql(400)
        end

        it 'responds with 400 when already expired' do
          valid_access_token.expire!
          delete :destroy, access_token: valid_access_token.code
          expect(response.status).to eql(400)
        end
      end
    end

    context 'when access_token is not provided' do
      it 'responds with 400' do
        expect {
          delete :destroy
        }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end
end
