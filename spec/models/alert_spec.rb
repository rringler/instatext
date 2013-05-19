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
		let(:alert_details) { { user_id: 1,
														instagram_id: 0001,
														instagram_username: 'test_user' } }

		describe '#find_or_create' do
			context 'when the alert is unique' do
				it 'creates a new alert' do
					Alert.first_or_create(alert_details)
					Alert.where(alert_details).size.should eq 1
				end
			end

			context 'when the alert is not unique' do
				it 'does not create a new alert' do
					Alert.first_or_create(alert_details)
					Alert.first_or_create(alert_details)
					Alert.where(alert_details).should_not eq 2
				end
			end
		end

		describe '#alert_exists?' do
			context 'when the alert already exists' do
				it 'returns true' do
					Alert.first_or_create(alert_details)
					Alert.alert_exists?(alert_details).should be_true
				end
			end

			context 'when the alert does not already exist' do
				it 'returns false' do
					Alert.alert_exists?(alert_details).should be_false
				end
			end
		end
	end
end