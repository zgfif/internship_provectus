# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby '2.5.1'

gem 'dotenv-rails', groups: %i[development test]

gem 'rails', '~> 5.2.0'
gem 'pg', '~> 0.18.4'
gem 'puma', '~> 3.11'
# Build JSONAPIs
gem 'jsonapi-rails', '~> 0.3.1'
# Database based asynchronous priority queue system
gem 'delayed_job_active_record', '~> 4.1', '>= 4.1.3'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'rubocop', '~> 0.58.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS),
# making cross-origin AJAX possible
# gem 'rack-cors'

gem 'google-api-client', '~> 0.23.7'
gem 'active_model_serializers', '~> 0.10.7'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails', '~> 3.7'
  gem 'database_cleaner', '~> 1.7.0'
  gem 'factory_bot_rails', '~> 4.11.0'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano', '~> 3.10', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rvm'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'figaro', '~> 1.1', '>= 1.1.1'
gem 'omniauth-google-oauth2', '~> 0.5.3'
gem 'jwt', '~> 1.5', '>= 1.5.4'
gem 'rack-cors', '~> 0.4.0'
gem 'daemons', '~> 1.2', '>= 1.2.6'
gem 'will_paginate', '~> 3.1', '>= 3.1.6'
gem 'api-pagination', '~> 4.8', '>= 4.8.1'
