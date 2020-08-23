require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  describe 'GET #show' do
    before(:each) do
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

  describe 'POST #create', focus: true do
    context 'when is successfully created' do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, params: { user: @user_attributes }
      end

      it 'renders the json representation for the user record just created' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(response.response_code).to eq(201)
        expect(user_response[:email]).to eql @user_attributes [:email]
      end
    end

    context 'when is not created' do
      before(:each) do
        # notice I'm not including the email
        @invalid_user_attributes = {
          password: '12345678',
          password_confirmation: '12345678'
        }
        post :create, params: { user: @invalid_user_attributes}
      end

      it 'renders the json errors on why the user could not be created' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(response.response_code).to eq(422)
        expect(user_response).to have_key(:errors)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end
    end
  end
end
