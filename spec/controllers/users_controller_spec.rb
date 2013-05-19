require 'spec_helper'

describe UsersController do

	describe "GET #new" do
		it 'renders the :new view' do
  		get :new
  		response.should render_template :new
  	end
	end

	describe "POST #create" do
		context 'when the new user is valid' do
			let(:user) { FactoryGirl.attributes_for(:user) }

			it 'creates a new user' do
				controller.stub_chain(:instagram_client, :user, :username)
									.and_return(user[:username])

			  expect{ post :create, user: user }.to change(User, :count).by(1)
				expect{ post :create, user: user }.to redirect_to(current_user)
			end
		end

		context 'when the new user is invalid' do
			let(:user) { FactoryGirl.attributes_for(:user, username: nil) }

			it 'redirects to the new user page' do
				controller.stub_chain(:instagram_client, :user, :username)
									.and_return(user[:username])

				expect{ post :create, user: user }.to_not change(User, :count)
				expect{ post :create, user: user }.to render_template :new
			end
		end
	end

  describe 'GET #show' do
  	let(:user1) { FactoryGirl.create(:user) }
  	let(:user2) { FactoryGirl.create(:user) }
  	let(:valid_feed) { %w['one', 'two', 'three'] }

  	context 'when the correct user is signed in' do
  		before :each do
  			sign_in(user1)
  			controller.stub_chain(:instagram_client, :user_media_feed)
									.and_return(valid_feed)

  		end

  		it "assigns the user's instance varibles" do
  			get :show, id: user1.id

	  		assigns(:username).should eq user1.username
	  		assigns(:feed).should eq valid_feed
	  	end

	  	it 'renders the show user template' do
	  		get :show, id: user1.id

	  		response.should render_template :show
	  	end
  	end

  	context 'when a different user is signed in' do
  		it "redirects to the current user's page" do
	  		sign_in(user2)

	  		get :show, id: user1.id

	  		response.should redirect_to user_path(user2)
	  	end
  	end

  	context 'when the user is not signed in' do
  		it 'redirects to the new session path' do
  			sign_out

  			get :show, id: user1.id

  			response.should redirect_to(new_session_path)
  		end
  	end
  end

  describe 'GET #edit' do
  	let!(:user) { FactoryGirl.create(:user_with_alerts) }
  	let(:valid_follows) { %w['one', 'two', 'three'] }

  	context 'when the user is signed in' do
  		before :each do
  			sign_in(user)
  			controller.stub_chain(:instagram_client, :user_follows)
									.and_return(valid_follows)
  		end

  		it "assigns the user's instance varibles" do
  			get :edit, id: user.id

	  		assigns(:user).should eq user
	  		assigns(:alerts).size.should eq 3
	  		assigns(:alerts).should eq user.alerts
	  		assigns(:follows).should eq valid_follows
	  	end

	  	it 'renders the show user template' do
	  		get :edit, id: user.id

	  		response.should render_template :edit
	  	end
  	end
  	
  	context 'when the user is not signed in' do
  		it 'redirects to the new session path' do
  			sign_out

  			get :edit, id: user.id
  			response.should redirect_to(new_session_path)
  		end
  	end
  end

  describe 'PUT #update' do
  	let(:user1) { FactoryGirl.create(:user) }
  	let(:user2) { FactoryGirl.create(:user) }

  	context 'when the correct user is signed in' do
  		it 'updates the user' do
  			sign_in(user1)

  			controller.stub_chain(:instagram_client, :user, :username)
									.and_return('test_user')
				
				# No idea why this isn't working; my PermittedParams class allows
				# params[:user][:username]
  			put :update, id: user1.id, user: { username: user1.username }

				response.should be_successful
  			response.should redirect_to edit_user_path(current_user)
  			User.find_by_id(user1.id).username.should eq "New Username"
  		end
  	end

  	context "when a different user is signed in" do
  		it "redirects to the current user's page" do
				sign_in(user2)

				put :update, id: user1.id
  			response.should redirect_to current_user
	  	end
	  end

  	context 'when the user is not signed in' do
  		it 'redirects to the new session path' do
  			sign_out

  			put :update, id: user1.id
  			response.should redirect_to(new_session_path)
  		end
  	end
  end

  describe 'DELETE #destroy' do
  	let(:user1) { FactoryGirl.create(:user) }
  	let(:user2) { FactoryGirl.create(:user) }

  	context 'when the correct user is signed in' do
  		it 'deletes the user' do
  			sign_in(user1)
  			expect{ delete :destroy, id: user1.id }.to change(User, :count).by(-1)
  		end
  	end

  	context 'when a different user is signed in' do
  		it "redirects to the current user's page" do
  			sign_in(user2)

  			delete :destroy, id: user1.id

  			response.should redirect_to current_user
  			expect{ delete :destroy, id: user1.id }.to_not change(User, :count)
  		end
  	end

  	context 'when the user is not signed in' do
  		it 'redirects to the new session path' do
  			sign_out

  			delete :destroy, id: user1.id

  			response.should redirect_to(new_session_path)
  			expect{ delete :destroy, id: user1.id }.to_not change(User, :count)
  		end
  	end
  end
end