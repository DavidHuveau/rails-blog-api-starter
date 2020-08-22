require 'rails_helper'

describe Api::V1::UsersController, type: :controller, focus: true do
  describe 'GET #show' do
    before :each do
      @user = FactoryGirl.create :user
      get :show, params: { id: @user.id}
    end

    it 'should returns the information about a reporter on a hash' do
      debugger
      expect(response.code).to eq '200'

      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql @user.email
    end
  end
end
