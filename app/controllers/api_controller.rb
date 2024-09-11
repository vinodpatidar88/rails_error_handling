class ApiController < ActionController::API
  before_action :authenticate
  rescue_from ApiExceptions::BaseException, with: :render_error_response
  attr_accessor :current_user

  def render_error_response(error)
    render json: error.to_json, status: error.code
  end

  def authenticate
    token = LoginToken.find_by(token: request.headers[:token])
    if token.present?
       token.user
    else
       raise ApiExceptions::UserError::AuthenticationError.new
    end
  end

  def authenticate_manually token
    if data = LoginToken.find_by(token: request.headers[:token])
       data.user
    end
  end
end
