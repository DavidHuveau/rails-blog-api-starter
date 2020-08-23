class Api::V1::UsersController < ApplicationController

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

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
