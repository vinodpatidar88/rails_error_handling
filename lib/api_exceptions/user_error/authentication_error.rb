module ApiExceptions
  class UserError < ApiExceptions::BaseException
    class AuthenticationError < ApiExceptions::UserError
    end
  end
end