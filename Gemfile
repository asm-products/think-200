source 'https://rubygems.org'

ruby '2.1.5'
gem 'rails',        '4.1.9'
gem 'sass-rails',   '~> 4.0.3'
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'jbuilder',     '~> 2.0'
gem 'bcrypt-ruby'
gem 'resque'
# gem 'resque-web', require: 'resque_web'
gem 'resque_solo'
gem 'newrelic_rpm'
gem 'figaro'
gem 'pg'
gem 'pry-rails'
gem 'whenever', '0.9.0', require: false  # 0.9.1 fails in capistrano
gem 'rspec', '~> 3.0'
gem 'rspec-webservice_matchers', '~> 4.0.0'
gem 'annotate'
gem 'haml'
gem 'kaminari'
gem 'friendly_id'
gem 'font-awesome-sass'
gem 'devise'
gem 'bootstrap-sass'

group :doc do
  gem 'sdoc', require: false
end

group :development, :test do
  # gem 'debugger'
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 3.0'
end

group :development do
  gem 'rails-erd'
  gem 'quiet_assets'
  gem 'capistrano', '~> 3.1.0'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'guard-rspec', require: false
  gem 'terminal-notifier-guard'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'fabrication'
  gem 'faker'
  gem 'timecop'
end
