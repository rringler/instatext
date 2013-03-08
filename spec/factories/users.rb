FactoryGirl.define do
	factory :user do
		sequence(:access_token) { |n| 'a' * 45 << "%04d" % n } 
		sequence(:username) { |n| "test_user%04d" % n }
		sequence(:phone) { |n| "734-883-%04d" % n }
	end

	factory :user_with_alerts, parent: :user do
		after(:create) do |user|
			FactoryGirl.create(:alert, user: user)
		end
	end
end