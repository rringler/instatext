class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    client = Instagram.client(access_token: session[:access_token])
    @username = client.user.username

    # create the new user
    params[:user][:access_token] = session[:access_token]
    params[:user][:username] = @username
  	@user = User.new(params[:user])

  	if @user.save
  		flash[:success] = "Phone number saved!"
  		redirect_to feed_path
  	else
  		render 'new'
  	end
  end
end