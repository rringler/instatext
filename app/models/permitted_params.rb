class PermittedParams < Struct.new(:params, :current_user)
	def user
		if current_user && current_user.admin?
			params.require(:user).permit!
    else
      params.require(:user).permit(user: { :access_token,
                                           :username,
                                           :phone } )
    end
  end
end