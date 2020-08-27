class Authentication < ActionController::API
  include Authenticable
end

RSpec.describe Authenticable do
  let(:authentication) { Authentication.new }

  describe '#current_user' do
    before do
      @user = FactoryGirl.create :user
      debugger
      request.headers["Authorization"] = @user.authentication_token
      authentication.stub(:request).and_return(request)
    end

    it 'returns the user from the authorization header' do
      expect(authentication.current_user.authentication_token).to eq @user.authentication_token
    end
  end
end
