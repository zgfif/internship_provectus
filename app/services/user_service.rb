# frozen_string_literal: true

class UserService
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
  end
end
