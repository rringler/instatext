class AlertsController < ApplicationController
  before_filter :signed_in?, only: [:destroy]

  include ApplicationHelper

	def sub_callback_get
		render text: params['hub.challenge']
	end

	def sub_callback_post
		Instagram.process_subscription(params[:body]) do |handler|
	  	handler.on_user_changed do |user_id, data|

        logger.debug "**** #{user_id}"
        logger.debug "**** #{data}"

  		  # TODO
  		 	# if Alert.where(instagram_id: user_id).any?
  		 	# 	Alert.where(instagram_id: user_id).each do |alert|
  		 	# 		#Alert.notify_user
  		 	# 	end
  		 	# end
	  	end
  	end
  end

  def create_sub
  	Thread.new do |t|
	    @sub = client.create_subscription('user', get_url(:sub_callback))
		  t.exit
		end

    redirect_to list_subs_path
  end

  def clear_subs
    client.subscriptions.each do |sub|
      client.delete_subscription(id: sub.id)
    end

    redirect_to list_subs_path
  end

  def list_subs
  	@subs = client.subscriptions
  end

  def destroy
    Alert.find(params[:id]).destroy
    redirect_to edit_user_path(current_user)
  end
end