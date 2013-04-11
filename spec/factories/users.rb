FactoryGirl.define do
	factory :user do
		sequence(:access_token) { |n| 'a' * 45 << "%04d" % n } 
		sequence(:username) { |n| "test_user%04d" % n }
		sequence(:phone) { |n| "734-883-%04d" % n }
	
		factory :user_with_alerts do
			max_alerts 10
		end

		factory :admin do
			max_alerts 10
			admin true
		end
	end
end