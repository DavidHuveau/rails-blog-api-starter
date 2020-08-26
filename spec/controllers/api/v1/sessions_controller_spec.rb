RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'POST #create' do
    before(:each) do
      @user = FactoryGirl.create :user
    end

    context 'when the credentials are correct' do
      before(:each) do
        post :create, params: {
          session: { email: @user.email, password: '12345678' }
        }
      end

      it 'returns the user record corresponding to the given credentials' do
        expect(response.response_code).to eq(200)

        @user.reload
        expect(json_response[:authentication_token]).to eq @user.authentication_token
      end
    end

    context 'when the credentials are incorrect' do
      before(:each) do
        post :create, params: {
          session: { email: @user.email, password: 'invalidpassword' }
        }
      end

      it 'returns a json with an error' do
        expect(response.response_code).to eq(422)
        expect(json_response[:errors]).to eq 'Invalid email or password'
      end
    end
  end
end
