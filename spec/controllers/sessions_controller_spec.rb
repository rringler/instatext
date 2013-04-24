require 'spec_helper'

describe SessionsController do
  describe "GET #new" do
  	it "renders the :new view" do
  		get :new
  		response.should render_template :new
  	end
	end

	describe "GET #connect" do
		it "redirects to the Instagram authorize url" do
			get :connect
			response.should redirect_to(Instagram.authorize_url(redirect_uri: get_url(:auth_callback)))
		end
	end

	describe "GET #auth_callback" do
		pending
	end
end