class Api::V1::SessionsController < ApplicationController
  def create
    user_password = params[:session][:password]
    user_email = params[:session][:email]
    user = user_email.present? && User.find_by(email: user_email)

    if user.valid_password?(user_password)
      sign_in user
      user.generate_authentication_token
      user.save
      render json: { data: user }
    else
      render json: { errors: 'Invalid email or password' }, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find_by(authentication_token: params[:id])
    user.set authentication_token: ''
    # user.unset :authentication_token
    head :no_content
  end
end
