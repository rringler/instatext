class UsersController < ApplicationController
  before_filter :signed_in?, only: [:show, :edit, :update, :destroy]

  require 'date'
  include ApplicationHelper

  def new
    @user = User.new
  end

  def create
    params[:user][:access_token] = session[:access_token]
    params[:user][:username] = instagram_client.user.username
  	user = User.create_from_params(permitted_params.user)
    #sub = instagram_client.create_subscription('user', url, options)

  	if user #&& sub
  		flash[:success] = 'Phone number saved!'
      session[:user_id] = user.id
  		redirect_to user_path(current_user)
  	else
      render 'new'
  	end
  end

  def show
    @username = current_user.username
    @feed = instagram_client.user_media_feed(count: 5)
  end

  def edit
    @user = current_user
    @alerts = current_user.alerts
    @follows = instagram_client.user_follows
  end

  def update
    if params.keys.include?('alerts')
      params['alerts'].each do |f|
        args = { user_id: current_user.id,
                 instagram_id: f,
                 instagram_username: instagram_client.user(f).username }
        if current_user.available_alerts?
          current_user.alerts.create_if_new(args)
        else
          flash[:error] = 'Exceeded maximum number of alerts.'
        end
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