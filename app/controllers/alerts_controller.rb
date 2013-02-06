class AlertsController < ApplicationController
  before_filter :signed_in?, only: [:destroy]

  include ApplicationHelper

  def webhook
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

  def destroy
    Alert.find(params[:id]).destroy
    redirect_to edit_user_path(current_user)
  end
end