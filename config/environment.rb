# Load the rails application
require File.expand_path('../application', __FILE__)

# Log colouring
require File.join(File.dirname(__FILE__), '../lib/log_colour')

# Initialize the rails application
Draww::Application.initialize!
