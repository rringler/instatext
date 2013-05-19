FactoryGirl.define do
	factory :user do
		sequence(:access_token) { |n| 'a' * 45 << "%04d" % n } 
		sequence(:username) { |n| "test_user%04d" % n }
		sequence(:phone) { |n| "734-883-%04d" % n }
		max_alerts 0

		factory :user_with_good_access_token do
			access_token "good_access_token"
		end
	
		factory :user_with_alerts do
			max_alerts 10

			after(:create) do |user|
				3.times do |i|
					user.create_alert_if_available(i, 'test_user')
				end
			end
		end

		factory :admin do
			max_alerts 10
			admin true
		end
	end
end