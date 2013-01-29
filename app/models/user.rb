class User < ActiveRecord::Base
  
  attr_accessible :access_token, :phone
end
