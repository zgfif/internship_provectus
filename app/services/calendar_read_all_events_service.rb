# frozen_string_literal: true

class CalendarReadAllEventsService < CalendarService
  attr_accessor :current_user, :events_available, :page_token

  extend Callable

  def initialize(current_user)
    super
    @page_token = nil
    @response = nil
    @all_events = []
    # TOTAL_EVENTS is constant from CalendarService, with value 2500
    @events_available = TOTAL_EVENTS
  end

  def perform
    loop do
      list_events_from_service
      push_response_events
      break unless !@page_token.nil? && @events_available.positive?
    end
    @all_events
  end

  def list_events_from_service
    @response = @service.list_events(
      DEFAULT_CALENDAR_ID,
      max_results: [@events_available, DEFAULT_EVENTS_NUMBER].min,
      single_events: REQUEST_SINGLE_EVENTS,
      order_by: REQUEST_ORDER_BY,
      time_min: REQUEST_TIME_MIN,
      page_token: @page_token
    )
  end

  def push_response_events
    if @response.items.empty?
      Rails.logger.info "No upcoming events found. #{Time.now.iso8601}, #{DEFAULT_CALENDAR_ID}"
    else
      @response.items.each do |event|
        @all_events.push(event)
      end
      @events_available -= @response.items.length
      @page_token = @response.next_page_token.presence
    end
  end
end
