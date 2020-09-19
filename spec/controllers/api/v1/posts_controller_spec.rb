require 'rails_helper'

describe Api::V1::PostsController, type: :controller do
  describe 'GET #index' do
    before(:all) do
      4.times do
        FactoryGirl.create(:post)
      end
      sleep 1
      user = FactoryGirl.create :user
      # api_authorization_header(user.authentication_token)
    end

    context 'when is not receiving any product_ids parameter' do
      before(:each) do
        get :index
      end

      it 'returns 4 records from the database' do
        expect(json_response[:data].size).to eq(4)
      end

      it { expect(response.response_code).to eq(200) }

      it 'returns the user object into each product' do
        json_response[:data].each do |post_response|
          expect(post_response[:user]).to be_present
        end
      end
    end

    context 'with pagination' do
      before(:each) do
        get :index, params: { page: 2, per_page: 2 }
      end

      it 'returns 2 records from the database' do
        expect(json_response[:data].size).to eq(2)
      end

      it { expect(response.response_code).to eq(200) }

      it 'have meta pagination tags' do
        expect(json_response).to have_key(:meta)
        expect(json_response[:meta]).to have_key(:pagination)
        expect(json_response[:meta][:pagination]).to have_key(:current_page)
        expect(json_response[:meta][:pagination]).to have_key(:per_page)
        expect(json_response[:meta][:pagination]).to have_key(:total_pages)
        expect(json_response[:meta][:pagination]).to have_key(:total_entries)
      end

      it 'have meta pagination values' do
        expect(json_response[:meta][:pagination][:current_page]).to eq(2)
        expect(json_response[:meta][:pagination][:per_page]).to eq(2)
        expect(json_response[:meta][:pagination][:total_pages]).to eq(2)
        expect(json_response[:meta][:pagination][:total_entries]).to eq(4)
      end

      it 'have links pagination tags' do
        expect(json_response).to have_key(:links)
        expect(json_response[:links]).to have_key(:first_page)
        expect(json_response[:links]).to have_key(:last_page)
        expect(json_response[:links]).to have_key(:previous_page)
        expect(json_response[:links]).to have_key(:next_page)
      end

      it 'have links pagination values' do
        expect(json_response[:links][:first_page]).not_to eq nil

        url = json_response[:links][:first_page]
        data = Rails.application.routes.recognize_path url
        expect(data).to eq({ controller: 'api/v1/posts', action: 'index' })

        params = Rack::Utils.parse_nested_query(URI.parse(url).query)
        expect(params).to eq({ 'page' => '1', 'per_page' => '2' })

        expect(json_response[:links][:next_page]).to eq('')
      end
    end

    context 'when post_ids parameter is sent' do
      before(:each) do
        @user = FactoryGirl.create :user
        3.times { FactoryGirl.create :post, user: @user }
        get :index, params: { post_ids: @user.post_ids.map(&:to_s) }
      end

      it 'returns 3 records from the database' do
        expect(json_response[:data].size).to eq(3)
      end

      it { expect(response.response_code).to eq(200) }

      it 'returns just the posts that belong to the user' do
        json_response[:data].each do |post_response|
          expect(post_response[:user][:email]).to eq @user.email
        end
      end
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
      expect(post_response[:data][:title]).to eq @post.title
    end

    it 'has the user as a embedded object' do
      expect(json_response[:data][:user][:email]).to eq @post.user.email
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
        expect(post_response[:data][:title]).to eq @post_attributes[:title]
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
        patch :update, params: { user_id: @user.id, id: @post.id, post: { title: 'An expensive computer' } }
      end

      it { expect(response.response_code).to eq(200) }

      it 'renders the json representation for the updated user' do
        post_response = json_response
        expect(post_response[:data][:title]).to eql 'An expensive computer'
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
