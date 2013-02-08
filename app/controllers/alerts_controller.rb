class AlertsController < ApplicationController
  before_filter :signed_in?, only: [:destroy]

  include ApplicationHelper

  def sub_callback_get
		render text: params['hub.challenge']
	end

	def sub_callback_post
  	Instagram.process_subscription(params[:body]) do |handler|
  		handler.on_user_changed do |user_id, data|
  			# TODO

  			# if Alert.where(instagram_id: user_id).any?
  			# 	Alert.where(instagram_id: user_id).each do |alert|
  			# 		#alert.notify_user
  			# 	end
  			# end
  		end
  	end
  end

  def create_sub
	  #url = ENV['SUBSCRIPTION_CALLBACK_URL']
	  #options = { client_secret: ENV['INSTAGRAM_CLIENT_SECRENT'] }
    sub = client.create_subscription('user', instagram_subscription_callback_url)
  end

  def list_subs
  	subs = client.subscriptions
  	render text: subs
  end

  def destroy
    Alert.find(params[:id]).destroy
    redirect_to edit_user_path(current_user)
  end
end