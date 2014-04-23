source 'https://rubygems.org'

# Ruby version
ruby '2.1.1'
#ruby-gemset=munro_mates_1_0

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'


# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

group :development do
	# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  	gem 'spring'
	# Use Capistrano for deployment
	# gem 'capistrano-rails', group: :development
end

group :development, :test do
	# Use sqlite3 as the database for Active Record
	gem 'sqlite3'
	gem 'rspec-rails', '2.13.1'
	gem 'guard-rspec', '2.5.0'
	gem 'spork-rails', '4.0.0'
	gem 'guard-spork', '1.5.0'
	gem 'childprocess', '0.3.6'
	# Use debugger
	gem 'debugger'
end

group :test do
	gem 'selenium-webdriver', '2.35.1'
	gem 'capybara', '2.1.0'
	gem 'factory_girl_rails', '4.2.0'
	gem 'cucumber-rails', '1.4.0', :require => false
	gem 'database_cleaner', github: 'bmabey/database_cleaner'
	# Linux.
	gem 'libnotify', '0.8.0'

	# Uncomment this line on OS X.
	# gem 'growl', '1.0.3'
	# Uncomment these lines on Windows.
	# gem 'rb-notifu', '0.0.4'
	# gem 'win32console', '1.3.2'
	# gem 'wdm', '0.1.0'
end

group :doc do
	# bundle exec rake doc:rails generates the API under doc/api.
	gem 'sdoc', '~> 0.4.0', require: false
end

group :production do
  gem 'pg', '0.17.1'
  gem 'rails_12factor', '0.0.2'
end
# Use unicorn as the app server
# gem 'unicorn'
