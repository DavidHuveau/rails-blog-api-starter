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
    # before(:each) do
    #   4.times { FactoryGirl.create :post }
    #   # sleep 1
    #   get :index
    # end

    # it { expect(response.response_code).to eq(200) }

    # it 'returns 4 records from the database' do
    #   expect(json_response.size).to eq(4)
    # end
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

  describe 'POST #create', focus: true do
    context 'when is successfully created' do
      before(:each) do
        user = FactoryGirl.create :user
        @post_attributes = FactoryGirl.build :post
        debugger
        api_authorization_header(user.authentication_token)
        post :create, params: {
          user_id: user.id,
          post: @post_attributes
        }
      end

      it { expect(response.response_code).to eq(201) }

      it 'renders the json representation for the post record just created' do
        post_response = json_response
        expect(post_response[:title]).to eql @post_attributes[:title]
      end

    end

    # context 'when is not created' do
    #   before(:each) do
    #     user = FactoryGirl.create :user
    #     @invalid_product_attributes = { title: 'Smart TV', price: 'Twelve dollars' }
    #     api_authorization_header user.auth_token
    #     post :create, params: { user_id: user.id, product: @invalid_product_attributes }
    #   end

    #   it 'renders an errors json' do
    #     product_response = json_response expect(product_response).to have_key(:errors)
    #   end

    #   it 'renders the json errors on why the user could not be created' do
    #     product_response = json_response
    #     expect(product_response[:errors][:price]).to include 'is not a number'
    #   end

    #   it { expect(response.response_code).to eq(422) }
    # end
  end
end
