source 'http://rubygems.org'

gem 'rails', '3.2.0'

gem 'mysql2'

gem 'json'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Use Thin instead of Webrick
# Start for dev with: thin start -p 10520
gem 'thin'

gem 'nifty-generators'

gem 'awesome_print'
gem 'paperclip', '~> 3.0'
gem 'kaminari', '~>0.13.0'

gem 'authlogic'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'

# robins voting stuff
group :test, :cucumber do
  gem 'rspec-rails' #, '~> 2.7.0'
  gem 'factory_girl'
  gem 'cucumber-rails'
  gem 'database_cleaner'
end

# Inline editing
gem 'best_in_place'

local_gemfile = File.dirname(__FILE__) + "/Gemfile.robin.rb"  # for my local gem's (e.g. sqlite) file in my local repo only
if File.file?(local_gemfile)
  self.instance_eval(Bundler.read_file(local_gemfile))
end

# note: run 'bundle install' for new gems
gem "mocha", :group => :test
