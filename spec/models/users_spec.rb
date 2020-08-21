require 'rails_helper'

# RSpec.describe "Posts", type: :request do
describe User, type: :model, focus: true do
  before { @user = FactoryGirl.build(:user) }
  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should be_valid }
end
