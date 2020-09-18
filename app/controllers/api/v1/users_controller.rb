class Api::V1::UsersController < ApplicationController
  include SmartRenderer

  before_action :authenticate_with_token, only: %i[show update destroy]

  def show
    render json: { data: current_user }
    # render_or_error(current_user, :ok)
  end

  def create
    user = User.create(user_params)
    render_or_error(user)
  end

  def update
    user = current_user
    user.update(user_params)
    render_or_error(user, :ok)
  end

  def destroy
    user = current_user
    user.destroy
    render json: { data: user }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :authorization)
  end
end
