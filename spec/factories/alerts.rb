FactoryGirl.define do
	factory :alert do
		association :user

		user_id 1
		instagram_id '001'
		instagram_username 'test_user'
	end
end