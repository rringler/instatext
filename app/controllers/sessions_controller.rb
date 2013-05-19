class SessionsController < ApplicationController

	before_filter :signed_out?, only: [:new, :connect]

	require 'instagram'
	include ApplicationHelper

	def new
	end

  def connect
    redirect_to Instagram.authorize_url(redirect_uri: get_url(:auth_callback))
  end

  def auth_callback
    @user = User.find_by_instagram_code(params[:code])
    sign_in(@user)
  end

  def destroy
  	sign_out
  	redirect_to root_path, notice: "Logged out."
  end
end
