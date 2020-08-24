class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  def show
    render json: @user
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
    if @user.update(user_params)
      render json: @user
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  def destroy
    if @user.destroy
      render json: @user, status: 200
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
