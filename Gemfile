source 'http://rubygems.org'

gem 'rails', '3.1.1'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'mysql2'

gem 'json'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
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

gem 'awesome_print'
gem 'paperclip'
gem 'authlogic'
gem 'kaminari'

# robins voting stuff
group :test, :cucumber do
  gem 'rspec-rails' #, '~> 2.7.0'
  gem 'factory_girl'
  gem 'cucumber-rails'
  gem 'database_cleaner'
end

local_gemfile = File.dirname(__FILE__) + "/Gemfile.robin.rb"  # for my local gem's (e.g. sqlite) file in my local repo only
if File.file?(local_gemfile)
  self.instance_eval(Bundler.read_file(local_gemfile))
end

# note: run 'bundle install' for new gems
