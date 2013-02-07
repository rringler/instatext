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
    url = ENV['SUBSCRIPTION_CALLBACK_URL']
    #options = { client_secret: ENV['INSTAGRAM_CLIENT_SECRENT'] }
    #sub = client.create_subscription('user', url, options)

  	if user #&& sub
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