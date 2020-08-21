require 'rails_helper'

# RSpec.describe "Posts", type: :request do
describe Api::V1::PostsController, type: :controller do

  describe 'index' do
    it 'should return all posts' do
      4.times do
        post = FactoryGirl.create(:post)
      end

      sleep 1

      payload = {}
      get :index, params: payload

      expect(response.response_code).to eq(200)
      expect(JSON.parse(response.body).size).to eq(4)
    end
  end
end
