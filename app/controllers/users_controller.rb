class UsersController < ApplicationController
  before_filter :signed_in?, only: [:show, :edit, :update, :destroy]

  require 'date'
  include ApplicationHelper

  def new
    @user = User.new
  end

  def create
    # create the new user
    params[:user][:access_token] = session[:access_token]
    params[:user][:username] = client.user.username
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
    @username = current_user.username
    @feed = client.user_media_feed(count: 5)
  end

  def edit
    @user = current_user
    @alerts = current_user.alerts
    @follows = client.user_follows
  end

  def update
    # Something is broken here.  Need to avoid the params.each if no new
    # checkboxes are checked.
    
    if params.keys.include?('alerts')
      params['alerts'].each do |f|
        args = { user_id: current_user.id,
                 instagram_id: f,
                 instagram_username: client.user(f).username }
        current_user.alerts.create_if_new(args)
      end
    end

    redirect_to edit_user_path(current_user)
  end

  def destroy
    current_user.destroy
    sign_out
    redirect_to root_path
  end
end