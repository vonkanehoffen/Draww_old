# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Draww::Application.initialize!

# For Authlogic-connect
OpenIdAuthentication.store = :file