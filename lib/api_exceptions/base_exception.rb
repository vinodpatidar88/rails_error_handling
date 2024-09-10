module ApiExceptions
  class BaseException < StandardError
    attr_reader :status, :code, :message, :error_code

    ERROR_DESCRIPTION = proc {|code, message| {status: "error", code: code, message: message} }
    ERROR_CODE_MAP = {
      "UserError::AuthenticationError"                    => ERROR_DESCRIPTION.call(401, "You are not logged in"),
      "InvalidRequestError"                               => ERROR_DESCRIPTION.call(422, "Invalid Request"),
    }.freeze

    def initialize options={}
      error_type = self.class.name.scan(/ApiExceptions::(.*)/).flatten.first
      ApiExceptions::BaseException::ERROR_CODE_MAP
        .fetch(error_type, {}).each do |attr, value|
        instance_variable_set("@#{attr}".to_sym, value)
      end
      # set custom message and error-code
      @message = options[:message] if options[:message]
      @error_code = options[:error_code] if options[:error_code]
    end

    def to_json(*_args)
      out = {code: code, message: message, status: status}
      out[:error_code] = error_code if error_code
      out.to_json
    end
  end
end
