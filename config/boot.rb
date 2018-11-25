ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'bootsnap/setup' # Speed up boot time by caching expensive operations.

require 'google/apis/calendar_v3'
require 'googleauth/stores/file_token_store'

require 'google/apis/plus_v1'
Google::Apis.logger.level = Logger::INFO
