# frozen_string_literal: true

class CalendarService
  # Global constants for inherited services
  TOTAL_EVENTS = 2500
  DEFAULT_EVENTS_NUMBER = 250
  DEFAULT_CALENDAR_ID = 'primary'
  # Global constants for requests of inherited services
  REQUEST_SINGLE_EVENTS = true
  REQUEST_ORDER_BY = 'startTime'
  REQUEST_TIME_MIN = Time.now.iso8601
  # Local constants for this service
  DEFAULT_CLIENT_ID = ENV['DEFAULT_CLIENT_ID']
  DEFAULT_CLIENT_SECRET = ENV['DEFAULT_CLIENT_SECRET ']
  DEFAULT_USER_ID = 'default'
  APP_NAME = 'PROP'
  TOKEN_PATH = Rails.root.join('config', 'token.yaml')
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR
  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

  TOKEN_CREDENTIAL_URI = 'https://accounts.google.com/o/oauth2/token'

  def initialize(user)
    @user = user
    @client = Signet::OAuth2::Client.new(
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      access_token: @user[:token],
      refresh_token: @user[:refresh_token],
      expires_at: @user[:expires_at],
      token_credential_uri: TOKEN_CREDENTIAL_URI
    )
    @service = Google::Apis::CalendarV3::CalendarService.new
    @service.client_options.application_name = 'PROP'
    @service.authorization = @client
  end
end
