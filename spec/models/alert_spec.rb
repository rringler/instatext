require 'spec_helper'

describe Alert do
	it 'has a valid factory' do
		FactoryGirl.create(:alert).should be_valid
	end

	describe 'validations' do 

		it 'is invalid without a user_id' do
			FactoryGirl.build(:alert, user_id: nil).should_not be_valid
		end

		it 'is invalid without a instagram_id' do
			FactoryGirl.build(:alert, instagram_id: nil).should_not be_valid
		end

		it 'is invalid without a instagram_username' do
			FactoryGirl.build(:alert, instagram_username: nil).should_not be_valid
		end
	end

	describe 'methods' do

		describe '#create_if_available' do 

			context 'if the user has available alerts' do

				it 'creates a new alert if the alert is unique' do
					user = FactoryGirl.create(:user_with_alerts)
					args = { 	user_id: 1, 
										instagram_id: 0001,
										instagram_username: 'test_user' }
					user.alerts.create_if_unique(args).should_not be_nil
				end

				it 'does not create a new alert if the alert is not unique' do
					user = FactoryGirl.create(:user_with_alerts)
					args = { 	user_id: 1, 
										instagram_id: 0001,
										instagram_username: 'test_user' }
					user.alerts.create_if_unique(args)
					user.alerts.create_if_unique(args).should be_nil
				end
			end
		end

		describe '#alert_exists?' do
			it 'returns true if the alert already exists' do
				user = FactoryGirl.create(:user_with_alerts)
				args = { 	user_id: 1, 
									instagram_id: 0001,
									instagram_username: 'test_user' }
				user.alerts.create_if_unique(args)
				Alert.alert_exists?(args).should be_true
			end

			it 'returns false if the alert does not already exist' do
				user = FactoryGirl.create(:user_with_alerts)
				args = { 	user_id: 1, 
									instagram_id: 0001,
									instagram_username: 'test_user' }
				Alert.alert_exists?(args).should be_false
			end
		end
	end
end