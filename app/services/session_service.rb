# frozen_string_literal: true

class SessionService
  attr_reader :auth_data, :user

  def initialize(auth_data)
    @auth_data = auth_data
    @info = @auth_data.info
    @credentials = @auth_data.credentials
    user!
  end

  def user!
    @user = User.find_or_initialize_by(email: @info.email).tap do |user|
      user.first_name = @info.first_name
      user.last_name = @info.last_name
      user.avatar = @info.image
      user.token = @credentials.token
      user.refresh_token = @credentials.refresh_token if new_refresh_token?
      user.expires_at = to_datetime(@credentials.expires_at)
      user.save!
    end
  end

  private

  def to_datetime(google_exp_at)
    Time.at(google_exp_at)
  end

  def new_refresh_token?
    @credentials.refresh_token.present?
  end
end
