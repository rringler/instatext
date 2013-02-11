# Instatext

Pet project to explore the Instagram and Twilio APIs via Rails.

## Dependencies

* Rails 3
* <a href="https://github.com/Instagram/instagram-ruby-gem">Instagram Ruby Gem</a>
* <a href="https://github.com/twilio/twilio-ruby">Twilio-ruby</a>

## Environment Variables

The app needs a few environment variables necessary to work with the APIs.  In development it's set up to look for a config/app_env_vars.rb to define the variables.  Please make sure these variables get loaded on your production machine as well.

`if !Rails.env.production?
	ENV['INSTAGRAM_CLIENT_ID'] = 'instagram client id'
	ENV['INSTAGRAM_CLIENT_SECRET'] = 'instagram client secret key'
	ENV['INSTAGRAM_AUTH_CALLBACK_URL'] = 'http://publicly-reachable-url/auth_callback'
	ENV['INSTAGRAM_SUB_CALLBACK_URL'] = 'http://publicly-reachable-url/sub_callback'
	ENV['TWILIO_ACCOUNT_SID'] = 'twilio account SID'
	ENV['TWILIO_AUTH_TOKEN'] = 'twilio auth token'
	ENV['SECRET_TOKEN'] = 'rails secret token'
end`
