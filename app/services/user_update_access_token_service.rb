# frozen_string_literal: true

class UserUpdateAccessTokenService < UserService
  def perform!
    # Refresh token is required
    if @client.expired?
      @client.refresh!
      @user[:token] = @client.access_token
      @user[:expires_at] = @client.expires_at
      @user.save
    end
  end
end
