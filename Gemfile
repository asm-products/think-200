source 'https://rubygems.org'

ruby '2.1.1'
gem 'rails', '4.0.4'
gem 'sprockets', '2.11.0' # 2.12.0 and sass-rails conflict: https://github.com/rails/sass-rails/issues/191
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'jbuilder'
gem 'bcrypt-ruby'
gem 'resque'
gem 'resque-web', require: 'resque_web'
gem 'resque_solo'
gem 'newrelic_rpm'
gem 'figaro'
gem 'pg'
gem 'pry-rails'
gem 'whenever', '0.9.0', require: false  # 0.9.1 fails in capistrano
gem 'rspec'
gem 'rspec-webservice_matchers'
gem 'annotate'
gem 'haml'


group :doc do
  gem 'sdoc', require: false
end

group :development, :test do
  gem 'debugger'
  gem 'dotenv-rails'
  gem 'rspec-rails'
  gem 'rails_layout', '~> 0.5'  # Bootstrap 3 layout generator
end

group :development do
  gem 'rails-erd'
  gem 'quiet_assets'
  gem 'capistrano', '~> 3.1.0'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'guard-rspec', require: false
  gem 'terminal-notifier-guard'
  gem 'spork-rails'
end

group :test do
  gem 'fabrication'
  gem 'faker'
  gem 'timecop'
end

# Paging
gem 'kaminari'

# Slugs and friendly id's
gem 'friendly_id'

# font-awesome
gem 'font-awesome-sass', '4.0.2'
gem 'devise', '3.2.2'

gem 'bootstrap-sass'
