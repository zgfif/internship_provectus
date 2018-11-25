# frozen_string_literal: true

class UserUpdateEventsAttributesService
  attr_accessor :current_user, :default_events_type, :default_events_priority

  extend Callable

  def initialize(current_user, params)
    @current_user = current_user
    @default_events_type = params[:default_events_type]
    @default_events_priority = params[:default_events_priority]
  end

  def perform
    raise ActionController::BadRequest unless events_defaults_present?
    raise ActionController::BadRequest unless events_defaults_integers?
    convert_events_defaults_to_integers
    validate_events_defaults
    update_events_defaults
  end

  def events_defaults_present?
    @default_events_type.present? && @default_events_priority.present?
  end

  def events_defaults_integers?
    pattern = /^[0-9]$/
    pattern.match(@default_events_type) && pattern.match(@default_events_priority)
  end

  def convert_events_defaults_to_integers
    @default_events_type = @default_events_type.to_i
    @default_events_priority = @default_events_priority.to_i
  end

  def validate_events_defaults
    validate_events_type if @default_events_type.present?
    validate_events_priority if @default_events_priority.present?
  end

  def update_events_defaults
    @current_user.default_events_type = @default_events_type.presence
    @current_user.default_events_priority = @default_events_priority.presence
    @current_user.save ? :ok : :conflict
  end

  def validate_events_type
    Enums::ValidateService.call('User', 'default_events_type', @default_events_type)
  end

  def validate_events_priority
    Enums::ValidateService.call('User', 'default_events_priority', @default_events_priority)
  end
end
