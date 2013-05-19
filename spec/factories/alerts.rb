FactoryGirl.define do
	factory :alert do
		#association :user

		user_id 1
		sequence(:instagram_id) { |n| "%03d" % n }
		sequence(:instagram_username) { |n| "test_user%04d" % n }
	end
end