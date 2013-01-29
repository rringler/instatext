class User < ActiveRecord::Base
  
  attr_accessible :access_token, :username, :phone

  validates :username, presence: true,
  										 uniqueness: true
end
