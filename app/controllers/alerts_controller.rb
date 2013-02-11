class AlertsController < ApplicationController
  before_filter :signed_in?, only: [:destroy]

  include ApplicationHelper

	def sub_callback_get
		render text: params['hub.challenge']
	end

	def sub_callback_post
		Instagram.process_subscription(params[:body]) do |handler|
	  	handler.on_user_changed do |user_id, data|

        logger.debug "**** Alerts#sub_callback_post: #{user_id}"
        logger.debug "**** Alerts#sub_callback_post: #{data}"

  		  # TODO
  		 	# if Alert.where(instagram_id: user_id).any?
  		 	# 	Alert.where(instagram_id: user_id).each do |alert|
  		 	# 		#Alert.notify_user
  		 	# 	end
  		 	# end
	  	end
  	end
  end

  # Temp action while debugging
  def create_sub
  	Thread.new do |t|
	    @sub = instagram_client.create_subscription('user', get_url(:sub_callback))
		  t.exit
		end

    redirect_to list_subs_path
  end

  # Temp action while debugging
  def clear_subs
    instagram_client.subscriptions.each do |sub|
      instagram_client.delete_subscription(id: sub.id)
    end

    redirect_to list_subs_path
  end

  # Temp action while debugging
  def list_subs
  	@subs = instagram_client.subscriptions
  end

  # Temp action while debugging
  def notify_user
    current_user.notify!(twilio_client)
    redirect_to current_user
  end

  def destroy
    Alert.find(params[:id]).destroy
    redirect_to edit_user_path(current_user)
  end
end