class ApplicationController < ActionController::Base
  before_action :authenticate_request!
  protected

  def authenticate_request!
    puts "Authenticating request..."
    if !payload || !JsonWebToken.valid_payload(payload.first)
      puts "Invalid payload: #{payload}"
      return invalid_authentication
    end

    load_current_user!
    invalid_authentication unless @current_user
  end


  def payload
    token = params[:jwt]
    JsonWebToken.decode(token)
  rescue
    nil
  end




  def invalid_authentication
    render json: {error: 'Invalid Request'}, status: :unauthorized
  end
end
