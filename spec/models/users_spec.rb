require 'rails_helper'

describe User, type: :model do
  before { @user = FactoryGirl.build(:user) }
  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should be_valid }

  it { should respond_to(:authentication_token) }
  it { should validate_uniqueness_of(:authentication_token)}

  describe "#generate_authentification_token!" do
    it "generates a unique token" do
      @user.generate_authentification_token!
      expect(@user.authentication_token).not_to be_nil
    end

    it "generates another token when one already has been taken" do
      existing_user = FactoryGirl.create(:user, authentication_token: "auniquetoken123")
      @user.generate_authentification_token!
      expect(@user.authentication_token).not_to eq existing_user.authentication_token
    end
  end
end
