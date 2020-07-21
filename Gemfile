# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby '2.5.1'

gem 'dotenv-rails', groups: %i[development test]

gem 'rails'
gem 'pg'
gem 'puma'
# Build JSONAPIs
gem 'jsonapi-rails'
# Database based asynchronous priority queue system
gem 'delayed_job_active_record'
gem 'bootsnap', require: false
gem 'rubocop', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS),
# making cross-origin AJAX possible
# gem 'rack-cors'

gem 'google-api-client'
gem 'active_model_serializers'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'capistrano', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-passenger'
  gem 'capistrano-rvm'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'figaro'
gem 'omniauth-google-oauth2'
gem 'jwt'
gem 'rack-cors'
gem 'daemons'
gem 'will_paginate'
gem 'api-pagination'
