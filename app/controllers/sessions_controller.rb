class SessionsController < ApplicationController

	before_filter :signed_in?, only: [:destroy]

	require "instagram"
	include ApplicationHelper

	def new
	end

	def create
	end

  def connect
    redirect_to Instagram.authorize_url(redirect_uri: CALLBACK_URL)
  end

  def callback
    response = Instagram.get_access_token(params[:code], redirect_uri: CALLBACK_URL)
    session[:access_token] = response.access_token
    client ||= instagram_client
    username = client.user.username

    user = User.find_by_username(username)
    if user.nil?
    	redirect_to new_user_path
    else
    	session[:user_id] = user.id
    	redirect_to user_path(current_user)
    end
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to root_path, notice: "Logged out."
  end
end
