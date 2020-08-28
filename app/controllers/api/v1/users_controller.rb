class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: %i[update destroy]
  
  def show
    render json: User.find(params[:id])
  end

  def create
    user = User.create(user_params)

    if user.persisted?
      render json: user, status: 201
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    user = current_user
    if user.update(user_params)
      render json: user, status: 200
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    user = current_user
    if user.destroy
      render json: @user, status: 200
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
