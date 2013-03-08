require 'spec_helper'

describe User do
	it 'has a valid factory' do
		FactoryGirl.create(:user).should be_valid
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
			FactoryGirl.create(:user).available_alerts?.should eq false
		end

		it 'is not an admin by default' do
			FactoryGirl.create(:user).admin?.should eq false
		end
	end

	describe 'alerts' do
		it 'has alerts' do
			FactoryGirl.create(:user_with_alerts).alerts.size.should eq 1
		end
	end
end