class Api::V1::UsersController < ApplicationController
  include SmartRenderer

  before_action :authenticate_with_token, only: %i[show update destroy]

  def create
    user = User.create(user_params)
    render_or_error(user)
  end

  def show
    render_or_error(current_user, 200)
  end

  def update
    user = current_user
    user.update(user_params)
    render_or_error(user, 200)
  end

  def destroy
    user = current_user
    user.destroy
    render_or_error(user, 200)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :authorization)
  end
end
