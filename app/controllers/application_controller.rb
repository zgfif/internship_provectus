# frozen_string_literal: true

class ApplicationController < ActionController::API
  # Specifically, the scope_name is defaulted to :current_user,
  # and may be set as serialization_scope :view_context.
  serialization_scope :view_context

  before_action :current_user

  NoToken = Class.new(StandardError)
  WrongDate = Class.new(StandardError)
  WrongEnum = Class.new(StandardError)
  ReAuth = Class.new(StandardError)
  InvalidToken = Class.new(StandardError)
  BadRequest = Class.new(StandardError)

  rescue_from ApplicationController::InvalidToken do
    render_error_page(status: 409, text: 'Your jwt is not correct here')
  end

  rescue_from ApplicationController::WrongEnum do
    render_error_page(status: 400, text: 'Wrong value of enum')
  end

  rescue_from ApplicationController::WrongDate do
    render_error_page(status: 409, text: 'Wrong format or value of datetime field(s)')
  end
  rescue_from ApplicationController::BadRequest do
    render_error_page(status: 400, text: 'Incorrect search data')
  end
  rescue_from ActiveRecord::RecordNotFound do
    render_error_page(status: 404, text: 'Record Not found')
  end

  rescue_from ApplicationController::NoToken do
    render_error_page(status: 401, text: 'No token')
  end

  rescue_from JWT::DecodeError do
    render_error_page(status: 403, text: 'Could not decode token')
  end

  rescue_from Google::Apis::ClientError do
    render_error_page(status: 409, text: 'Incorrect value required of field(s)')
  end

  rescue_from ApplicationController::ReAuth do
    render_error_page(status: 403, text: 'Please, log in agian')
  end

  rescue_from Signet::AuthorizationError do
    render_error_page(status: 403, text: 'Please re-authorize via index page')
  end

  private

  def check_enum(enum_name, value)
    model = controller_name.classify
    Enums::ValidateService.call(model, enum_name, value)
  end

  def authentication_service
    @authentication_service ||= AuthenticationService.new(token)
  end

  def current_user
    @current_user ||= authentication_service.user
  end

  def render_error_page(status:, text:)
    render json: { error: [message: "#{status} #{text}"] }, status: status
  end

  def token
    raise ApplicationController::NoToken unless token?
    bearer.scan(/Bearer(.*)$/).flatten&.last&.strip
  end

  def token?
    bearer.present?
  end

  def bearer
    request.env['HTTP_AUTHORIZATION']
  end
end
