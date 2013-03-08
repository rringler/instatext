require 'spec_helper'

describe Alert do
	it 'has a valid factory' do
		FactoryGirl.create(:alert).should be_valid
	end

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