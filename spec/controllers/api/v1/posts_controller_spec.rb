require 'rails_helper'

describe Api::V1::PostsController, type: :controller do
  describe 'GET #index' do
    it 'returns 4 records from the database' do
      4.times do
        post = FactoryGirl.create(:post)
      end

      sleep 1

      get :index

      expect(response.response_code).to eq(200)
      expect(json_response.size).to eq(4)
    end
  end

  describe 'GET #show' do
    before(:each) do
      @post = FactoryGirl.create :post
      get :show, params: { id: @post.id }
    end

    it { expect(response.response_code).to eq(200) }

    it 'returns the information about a reporter on a hash' do
      post_response = json_response
      expect(post_response[:title]).to eq @post.title
    end
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        user = FactoryGirl.create :user
        @post_attributes = FactoryGirl.attributes_for :post
        api_authorization_header(user.authentication_token)
        post :create, params: { user_id: user.id, post: @post_attributes }
      end

      it { expect(response.response_code).to eq(201) }

      it 'renders the json representation for the post record just created' do
        post_response = json_response
        expect(post_response[:title]).to eq @post_attributes[:title]
      end
    end

    context 'when is not created' do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_post_attributes = { published: 'abcd' }
        api_authorization_header(user.authentication_token)
        post :create, params: { user_id: user.id, post: @invalid_post_attributes }
      end

      it { expect(response.response_code).to eq(422) }

      it 'renders an errors json' do
        post_response = json_response
        expect(post_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        post_response = json_response
        expect(post_response[:errors][:title]).to include "can't be blank"
      end
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      @user = FactoryGirl.create :user
      @post = FactoryGirl.create :post, user: @user
      api_authorization_header(@user.authentication_token)
    end

    context 'when is successfully updated' do
      before(:each) do
        patch :update, params: { user_id: @user.id, id: @post.id, post: { title: 'An expensive TV' } }
      end

      it { expect(response.response_code).to eq(200) }

      it 'renders the json representation for the updated user' do
        post_response = json_response
        expect(post_response[:title]).to eql 'An expensive TV'
      end
    end

    context 'when is not updated' do
      before(:each) do
        patch :update, params: { user_id: @user.id, id: @post.id, post: { title: '' } }
      end

      it { expect(response.response_code).to eq(422) }

      it 'renders an errors json' do
        post_response = json_response
        expect(post_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        post_response = json_response
        expect(post_response[:errors][:title]).to include "can't be blank"
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create :user
      @post = FactoryGirl.create :post, user: @user
      api_authorization_header(@user.authentication_token)
      delete :destroy, params: { user_id: @user.id, id: @post.id }
    end

    it { expect(response.response_code).to eq(200) }
  end
end
