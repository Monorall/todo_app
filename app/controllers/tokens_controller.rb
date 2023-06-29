class TokensController < ApplicationController
  before_action :authenticate_request!
  def create
    # Идентификация пользователя
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
      token = JWT.encode(payload, Rails.application.secrets.secret_key_base)

      refresh_token = SecureRandom.urlsafe_base64(64)
      user.update(refresh_token: refresh_token, refresh_token_expires_at: 30.days.from_now)

      render json: { access_token: token, refresh_token: refresh_token, message: 'Logged in successfully.' }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def refresh
    user = User.find_by(refresh_token: params[:refresh_token])

    if user && DateTime.now < user.refresh_token_expires_at
      payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
      token = JWT.encode(payload, Rails.application.secrets.secret_key_base)

      refresh_token = SecureRandom.urlsafe_base64(64)
      user.update(refresh_token: refresh_token, refresh_token_expires_at: 30.days.from_now)

      render json: { access_token: token, refresh_token: refresh_token }
    else
      render json: { error: 'Invalid or expired refresh token' }, status: :unauthorized
    end
  end
end
