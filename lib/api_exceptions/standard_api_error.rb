module ApiExceptions  
  class StandardApiError < ApiExceptions::BaseException
    attr_accessor :code, :message, :status
    def initialize(message, code, status=nil)
      self.message = message
      self.code = code
      self.status = status || "error"
    end
  end
end