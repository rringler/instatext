class AlertsController < ApplicationController
  before_filter :signed_in?, only: [:destroy]

  include ApplicationHelper

  def destroy
    Alert.find(params[:id]).destroy
    redirect_to edit_user_path(current_user)
  end
end