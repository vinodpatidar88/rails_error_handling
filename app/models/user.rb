class User < ActiveRecord::Base
    has_many :login_tokens
    enum status: %i[inactive active]
    validates :email, uniqueness: true, presence: true
    validates :mobile_number, uniqueness: true, presence: true
end