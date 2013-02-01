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

  def sign_out
  	session[:user_id] = nil
    @current_user = nil
  end
end
