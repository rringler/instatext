require 'spec_helper'

describe SessionsController do
  describe 'GET #new' do
  	it 'renders the :new view' do
  		get :new
  		response.should render_template :new
  	end
	end

	describe 'GET #connect' do
		it 'redirects to the Instagram authorize url' do
			get :connect
			response.should redirect_to(Instagram.authorize_url(redirect_uri: get_url(:auth_callback)))
		end
	end

	describe 'GET #auth_callback' do
		context 'for a new user' do
			it 'redirects to the new_user_path' do
				User.should_receive(:find_by_instagram_code).and_return(nil)

			  get :auth_callback, { code: "redirect_code" }
				response.should redirect_to(new_user_path)
			end
		end

		context 'for an existing user' do
			let(:user) { FactoryGirl.create(:user) }

			it 'redirects to the users page' do
				User.should_receive(:find_by_instagram_code).and_return(user)

			  get :auth_callback, { code: "redirect_code" }
				response.should redirect_to(user)
			end
		end
	end

	describe 'GET #destroy' do
		before :each do
			get :destroy 
		end

		it 'signs the user out' do
			session[:user_id].should be_nil
			@current_user.should be_nil
		end

		it 'redirects to the root_path' do
			response.should redirect_to(root_path)
		end
	end
end