RSpec.shared_context 'authorized context', authorized: true do
  before do
    request.env['HTTP_AUTHORIZATION'] = "Token token=#{valid_access_token.code}"
  end

  let(:valid_access_token) { FactoryGirl.create(:access_token, user: user) }
  let!(:user) do
    defined?(super) ? super() : FactoryGirl.create(:user)
  end

  it_behaves_like 'checking authorization'
end

RSpec.shared_examples 'checking authorization' do
  context 'when access_token is provided' do
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
    before do
      request.env['HTTP_AUTHORIZATION'] = nil
    end

    it 'responds with 401' do
      do_request
      expect(response.status).to eql(401)
    end
  end
end
