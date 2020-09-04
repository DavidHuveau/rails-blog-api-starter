require 'rails_helper'

describe Api::V1::PostsController, type: :controller, focus: true do
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
end
