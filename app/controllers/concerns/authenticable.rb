module Authenticable
  # Devise methods overwrites
  def current_user
    # @current_user ||= User.find_by(authentication_token: request.headers['Authorization'])
    return @current_user if @current_user

    token = request.headers['Authorization']
    return nil if token.nil?

    # decoded = JsonWebToken.decode(header)
    # @current_user = User.find(decoded[:user_id])
    # rescue ActiveRecord::RecordNotFound
    User.find_by(authentication_token: token)
  end

  def authenticate_with_token
    return if user_signed_in?

    render json: { errors: 'Not authenticated' }, status: :unauthorized
  end

  private

  def user_signed_in?
    current_user.present?
  end
end
