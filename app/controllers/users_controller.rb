class UsersController < ApplicationController
  before_filter :signed_in?, only: [:show, :edit, :update, :destroy]
  before_filter :correct_user?, only: [:show, :update, :destroy]

  require 'date'
  include ApplicationHelper

  def new
    @user = User.new
  end

  def create
    params[:user][:access_token] = cookies[:access_token]
    params[:user][:username] = instagram_client.user.username
  	user = User.new(permitted_params.user)

  	if user.valid? #&& subcribe
      user.save
  		flash[:success] = 'Phone number saved!'
      sign_in(user)

      #subscribe = instagram_client.create_subscription('user', url, options)
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
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
    end

    if params.keys.include?('alerts')
      params['alerts'].each do |instagram_id|
        instagram_username = instagram_client.user(instagram_id).username
        @user.create_alert_if_available(instagram_id, instagram_username)
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