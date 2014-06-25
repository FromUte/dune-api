RSpec.shared_examples 'checking authorization' do
  let(:valid_access_token) { FactoryGirl.create(:access_token, user: user) }

  context 'when access_token is provided' do
    before do
      request.env['HTTP_AUTHORIZATION'] = "Token token=#{valid_access_token.code}"
    end

    context 'and is not valid' do
      it 'responds with 401 when inexistant' do
        request.env['HTTP_AUTHORIZATION'] = 'Token token=invalid-access-token'
        do_request
        expect(response.status).to eql(401)
      end

      it 'responds with 401 when expired' do
        valid_access_token.expire!
        request.env['HTTP_AUTHORIZATION'] = "Token token=#{valid_access_token.code}"
        do_request
        expect(response.status).to eql(401)
      end
    end
  end

  context 'when access_token is not provided' do
    it 'responds with 401' do
      do_request
      expect(response.status).to eql(401)
    end
  end
end
