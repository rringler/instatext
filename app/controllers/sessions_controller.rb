class SessionsController < ApplicationController

	before_filter :signed_in?, only: [:destroy]
  before_filter :signed_out?, only: [:new, :connect]

	require 'instagram'
	include ApplicationHelper

	def new
	end

  def connect
    redirect_to Instagram.authorize_url(redirect_uri: get_url(:auth_callback))
  end

  def auth_callback
    response = Instagram.get_access_token(params[:code],
                                          redirect_uri: get_url(:auth_callback))
    session[:access_token] = response.access_token
    username = instagram_client.user.username

    user = User.find_by_username(username)
    if user.nil?
    	redirect_to new_user_path
    else
    	session[:user_id] = user.id
    	redirect_to current_user
    end
  end

  def destroy
  	sign_out
  	redirect_to root_path, notice: "Logged out."
  end
end
