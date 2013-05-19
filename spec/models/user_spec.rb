require 'spec_helper'

describe User do
	it 'has valid factories' do
		FactoryGirl.create(:user).should be_valid
		FactoryGirl.create(:user_with_alerts).should be_valid
		FactoryGirl.create(:user_with_alerts).alerts.size.should eq 3
		FactoryGirl.create(:admin).should be_valid
	end

	describe 'validations' do 
		describe 'username' do
			it 'is unique' do
				user1 = FactoryGirl.create(:user)
				user2 = FactoryGirl.build(:user, username: user1.username).should_not be_valid
			end

			it 'cannot be nil' do
				FactoryGirl.build(:user, username: nil).should_not be_valid
			end
		end

		describe 'phone number' do
			it 'is unique' do
				user1 = FactoryGirl.create(:user)
				user2 = FactoryGirl.build(:user, phone: user1.phone).should_not be_valid
			end

			it 'cannot be nil' do
				FactoryGirl.build(:user, phone: nil).should_not be_valid
			end
		end
	end

	describe 'default users' do 
		it 'do not have available alerts' do
			FactoryGirl.create(:user).max_alerts.should eq 0
		end

		it 'are not admins' do
			FactoryGirl.create(:user).admin?.should be_false
		end
	end

	describe 'methods' do
		describe '#available_alerts?' do
			context 'when the user has available alerts' do
				let(:user) { FactoryGirl.create(:user_with_alerts) }

				it 'should return true' do
					user.available_alerts?.should be_true
				end
			end

			context 'when the user does not have available alerts' do
				let(:user) { FactoryGirl.create(:user) }

				it 'should return false' do
					user.available_alerts?.should be_false
				end
			end
		end

		describe '#set_max_alerts' do
			context 'when the user is an admin' do
				let(:user) { FactoryGirl.create(:admin) }

				it 'should change max_alert in the database' do
					user.set_max_alerts!(10)
					User.find(user.id).max_alerts.should eq 10
				end
			end

			context 'when the user is not an admin' do
				let(:user) { FactoryGirl.create(:user) }

				it 'should change max_alert in the database' do
					user.set_max_alerts!(10)
					User.find(user.id).max_alerts.should_not eq 10
				end
			end
		end

		describe '#create_alert_if_available' do
			context 'when the user has available alerts' do
				let(:user) { FactoryGirl.create(:user_with_alerts) }

				it 'creates a new alert' do
					user.create_alert_if_available(100, 'test_user').should_not be_nil
				end
			end

			context 'when the user does not have available alerts' do
				let(:user) { FactoryGirl.create(:user) }

				it 'does not create a new alert' do
					user.create_alert_if_available(100, 'test_user').should be_nil
				end
			end
		end
	end
end