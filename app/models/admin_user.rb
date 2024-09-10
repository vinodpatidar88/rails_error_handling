class AdminUser < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[email role created_at] + _ransackers.keys
  end

  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable
end
