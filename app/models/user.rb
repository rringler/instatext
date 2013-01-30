class User < ActiveRecord::Base
  
  attr_accessible :access_token, :username, :phone

  validates :username, presence: true,
  										 uniqueness: true

  def self.from_params(params)
  	where(params.slice("username")).first
  end

  def self.create_from_params(params)
  	create! do |user|
  		user.access_token = params["access_token"]
  		user.username			= params["username"]
  		user.phone				= params["phone"]
  	end
  end
end
