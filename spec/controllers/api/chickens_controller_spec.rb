require 'rails_helper'

describe Api::ChickensController, type: :controller do
  describe 'index' do
    it 'should return an header ok' do
      payload = {}
      get :index, params: payload
      expect(response.response_code).to eq(200)
    end
  end
end
