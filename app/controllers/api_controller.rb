class ApiController < ActionController::API
  before_action :authenticate
  rescue_from ApiExceptions::BaseException, with: :render_error_response
  attr_accessor :current_user

  def authenticate
    token = LoginToken.find_by(token: request.header[:token])
    if token.blank?
       token.user
    else
       raise ApiExceptions::UserError::AuthenticationError.new
    end
  end
end
