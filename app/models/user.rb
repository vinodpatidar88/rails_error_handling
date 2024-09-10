class User < ActiveRecord::Base
    has_many :login_tokens
end