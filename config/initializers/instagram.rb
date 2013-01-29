require "instagram"

Instagram.configure do |config|
  config.client_id = ENV['INSTAGRAM_CLIENT_ID']
  config.client_secret = ENV['INSTAGRAM_CLIENT_SECRET']
end

CALLBACK_URL = ENV['INSTAGRAM_CALLBACK_URL']
