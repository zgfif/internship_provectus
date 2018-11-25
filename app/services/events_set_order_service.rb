# frozen_string_literal: true

class EventsSetOrderService
  attr_accessor :events, :params

  PERMITTED_ATTRIBUTES = %w[title description location priority event_type
                            priority event_type start_date end_date
                            google_event_id"].freeze

  def self.call(events, params)
    new(events, params).fetch
  end

  def initialize(events, params)
    @events = events
    @params = params
  end

  def fetch
    set_events_order! if sort_params_present?
    @events
  end

  def set_events_order!
    raise ActionController::BadRequest unless sort_attribute_permitted?
    @events = @events.order("#{@params[:attribute]} #{@params[:order]}")
  end

  def sort_params_present?
    @params[:attribute] && @params[:order]
  end

  def sort_attribute_permitted?
    PERMITTED_ATTRIBUTES.include? @params[:attribute]
  end
end
