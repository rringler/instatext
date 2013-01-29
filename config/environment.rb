# Load the rails application
require File.expand_path('../application', __FILE__)

# Load the app's custom environment variables here, so that they are
# loaded before environments/*.rb
app_env_vars = File.join(Rails.root, 'config', 'app_env_vars.rb')
load(app_env_vars) if File.exists?(app_env_vars)

# Initialize the rails application
Instatext::Application.initialize!