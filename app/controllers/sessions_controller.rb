# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :current_user

  def signin
    if omni_auth?
      @user = session_service.user!
      token = JwtToken::GenerationService.call(@user)
      render json: { jwt: token, user: @user }, status: :ok
    else
      head :bad_request
    end
  end

  private

  def omni_auth?
    request.env['omniauth.auth'].present?
  end

  def session_service
    @session_service ||= SessionService.new(request.env['omniauth.auth'])
  end
end
