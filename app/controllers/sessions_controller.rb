require "instagram"

class SessionsController < ApplicationController
  def connect
    redirect_to Instagram.authorize_url(redirect_uri: CALLBACK_URL)
  end

  def callback
    response = Instagram.get_access_token(params[:code], redirect_uri: CALLBACK_URL)
    session[:access_token] = response.access_token
    client = Instagram.client(access_token: session[:access_token])
    @username = client.user.username

    current_user = User.find_by_username(@username)
    if current_user.nil?
    	redirect_to new_user_path(access_token: session[:access_token])
    else
    	redirect_to feed_path(username: @username)
    end
  end
end
