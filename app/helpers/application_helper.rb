module ApplicationHelper
  def client(token=session[:access_token])
    @client ||= Instagram.client(access_token: token)
  end

	def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

	def signed_in?
  	redirect_to new_session_path unless current_user
  end

  def signed_out?
    redirect_to user_path(current_user) if current_user
  end

  def sign_out
  	session[:user_id] = nil
    @current_user = nil
  end

  def get_url(url)
    case url
      when :auth_callback
        @instagram_auth_callback_url ||= ENV['INSTAGRAM_AUTH_CALLBACK_URL']
      when :sub_callback
        @instagram_sub_callback_url ||= ENV['INSTAGRAM_SUB_CALLBACK_URL']
    end
  end
end
