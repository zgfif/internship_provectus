# frozen_string_literal: true

class AuthenticationService
  # This constant shows time of activity (seconds) of JWT token
  EXPIRE_TIME = 604_800

  def initialize(token)
    @token = token
  end

  def user
    @user ||= fetch_user
  end

  private

  def fetch_user
    correct_token? ? process_data : raise_token_exception
  end

  def correct_token?
    right_hash? && exist_user
  end

  def process_data
    process_access_token
    return_current_user
  end

  def exist_user
    User.find(payload['user_id'])
  end

  def right_hash?
    payload['user_id'] && payload['created']
  end

  def payload
    JwtService.decode(@token)
  end

  def actual_token?
    created = payload['created'].to_datetime
    (Time.now - created) < EXPIRE_TIME
  end

  def return_current_user
    actual_token? ? exist_user : raise(ApplicationController::ReAuth)
  end

  def process_access_token
    UserUpdateAccessTokenService.new(exist_user).perform!
  end

  def raise_token_exception
    raise ApplicationController::InvalidToken
  end
end
