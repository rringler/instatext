class UsersController < ApplicationController
  before_filter :signed_in?, only: [:show, :edit]

  include ApplicationHelper

  def new
    @user = User.new
  end

  def create
    # reuse the existing instagram connection or make a new one
    @client ||= instagram_client

    # create the new user
    params[:user][:access_token] = session[:access_token]
    params[:user][:username] = @client.user.username
  	user = User.create_from_params(params[:user])

    # if the user saves set @current_user and redirect to feed,
    # else show the phone number form again
  	if user
  		flash[:success] = "Phone number saved!"
      session[:user_id] = user.id
  		redirect_to user_path(current_user)
  	else
  		render 'new'
  	end
  end

  def show
    @client ||= instagram_client(current_user.access_token)
    @username = current_user.username
    @feed = @client.user_media_feed(count: 5)
    #@recent_media_items = client.user_recent_media
  end

  def edit
    @user = current_user
  end
end