class Authentication < ActionController::API
  include Authenticable
end

RSpec.describe Authenticable, focus: true do
  let(:authentication) { Authentication.new }

  describe '#current_user' do
    before do
      @user = FactoryGirl.create :user
      api_authorization_header(@user.authentication_token)
      authentication.stub(:request).and_return(request)
    end

    it 'returns the user from the authorization header' do
      expect(authentication.current_user.authentication_token).to eq @user.authentication_token
    end
  end

  describe '#authenticate_with_token' do
    before do
      @user = FactoryGirl.create :user
      authentication.stub(:current_user).and_return(nil)
      response.stub(:response_code).and_return(401)
      response.stub(:body).and_return({ 'errors' => 'Not authenticated' }.to_json)
      authentication.stub(:response).and_return(response)
    end

    it 'render a json error message' do
      expect(response.response_code).to eq(401)
      expect(json_response[:errors]).to eql 'Not authenticated'
    end
  end
end
