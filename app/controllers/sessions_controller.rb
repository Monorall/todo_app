class SessionsController < Devise::SessionsController
  skip_before_action :authenticate_request!, only: [:new, :create]
  def create
    super do
      if current_user
        jwt = JsonWebToken.encode({user_id: current_user.id})
        cookies[:jwt] = { value: jwt, httponly: true }
      end
    end
  end

  def destroy
    cookies.delete(:jwt)
    super
  end
end