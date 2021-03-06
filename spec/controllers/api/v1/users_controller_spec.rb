require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  describe 'GET #show' do
    context 'with authorization header' do
      before(:each) do
        @user = FactoryGirl.create :user
        api_authorization_header(@user.authentication_token)
        get :show, params: { id: @user.id }
      end

      it 'should returns the information about a reporter on a hash' do
        expect(response.response_code).to eq(200)
        user_response = json_response
        expect(user_response[:data][:email]).to eq @user.email
      end

      it 'has the post ids as an embedded object' do
        expect(json_response[:data][:post_ids]).to eql []
      end
    end

    context 'without authorization header' do
      before(:each) do
        @user = FactoryGirl.create :user
        get :show, params: { id: @user.id }
      end

      it 'should returns the information about a reporter on a hash' do
        expect(response.response_code).to eq(401)
        expect(json_response[:errors]).to eql 'Not authenticated'
      end
    end
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, params: { user: @user_attributes }
      end

      it 'renders the json representation for the user record just created' do
        expect(response.response_code).to eq(201)
        user_response = json_response
        expect(user_response[:data][:email]).to eql @user_attributes [:email]
      end
    end

    context 'when is not created' do
      before(:each) do
        # notice I'm not including the email
        invalid_user_attributes = {
          password: '12345678',
          password_confirmation: '12345678'
        }
        post :create, params: { user: invalid_user_attributes }
      end

      it 'renders the json errors on why the user could not be created' do
        user_response = json_response
        expect(response.response_code).to eq(422)
        expect(user_response).to have_key(:errors)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end
    end
  end

  describe 'PUT/PATCH #update' do
    context 'when is successfully updated' do
      before(:each) do
        user = FactoryGirl.create :user
        api_authorization_header(user.authentication_token)
        patch :update, params: { id: user.id, user: { email: 'newmail@example.com' } }
      end

      it 'renders the json representation for the updated user' do
        user_response = json_response
        expect(response.response_code).to eq(200)
        expect(user_response[:data][:email]).to eq 'newmail@example.com'
      end
    end

    context 'when is not created' do
      before(:each) do
        user = FactoryGirl.create :user
        api_authorization_header(user.authentication_token)
        patch :update, params: { id: user.id, user: { email: 'bademail.com' } }
      end

      it 'renders an errors json' do
        user_response = json_response
        expect(response.response_code).to eq(422)
        expect(user_response).to have_key(:errors)
        expect(user_response[:errors][:email]).to include 'is invalid'
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'renders the json representation after deleted user' do
      user = FactoryGirl.create :user
      api_authorization_header(user.authentication_token)
      delete :destroy, params: { id: user.id }

      expect(response.response_code).to eq(200)
    end
  end
end
