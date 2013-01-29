class FeedController < ApplicationController
  def index
    redirect_to controller: 'sessions', action: 'connect' if !session[:access_token] 

    client = Instagram.client(access_token: session[:access_token])
    @user = client.user
    @feed = client.user_media_feed
    @recent_media_items = client.user_recent_media
  end
end
