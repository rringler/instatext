require 'spec_helper'

describe User do
	it 'has valid factories' do
		FactoryGirl.create(:user).should be_valid
		FactoryGirl.create(:user_with_alerts).should be_valid
		FactoryGirl.create(:admin).should be_valid
	end

	describe 'username' do
		it 'is invalid without a username' do
			FactoryGirl.build(:user, username: nil).should_not be_valid
		end

		it 'has a unique username' do
			user1 = FactoryGirl.create(:user)
			user2 = FactoryGirl.build(:user, username: user1.username).should_not be_valid
		end
	end

	describe 'phone' do
		it 'is invalid without a phone number' do
			FactoryGirl.build(:user, phone: nil).should_not be_valid
		end

		it 'has a unique phone number' do
			user1 = FactoryGirl.create(:user)
			user2 = FactoryGirl.build(:user, phone: user1.phone).should_not be_valid
		end
	end

	describe 'defaults' do 
		it 'does not have available alerts by default' do
			FactoryGirl.create(:user).max_alerts.should eq 0
		end

		it 'is not an admin by default' do
			FactoryGirl.create(:user).admin?.should be_false
		end
	end

	describe 'method available_alerts?' do
		
		it 'should return false if there are not any available alerts' do
			FactoryGirl.create(:user).available_alerts?.should be_false
		end

		it 'should return true if there are available alerts' do
			FactoryGirl.create(:user_with_alerts).available_alerts?.should be_true
		end
	end

	describe 'method set_max_alerts' do
		
		it 'should persist max alert changes to the database' do
			user = FactoryGirl.create(:admin)
			user.set_max_alerts!(10)
			User.find(user.id).max_alerts.should eq 10
		end
	end
end