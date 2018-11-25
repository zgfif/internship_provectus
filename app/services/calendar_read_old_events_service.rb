# frozen_string_literal: true

class CalendarReadOldEventsService < CalendarService
  attr_reader :all_events, :start_date, :end_date, :events_number

  extend Callable

  def initialize(current_user, params)
    super(current_user)
    @all_events = []
    @start_date = params[:start_date] ? add_plus(params[:start_date]) : 1.month.ago.iso8601
    @end_date = params[:end_date] ? add_plus(params[:end_date]) : Time.now.iso8601
    @events_number = params[:events_number] ? params[:events_number].to_i : DEFAULT_EVENTS_NUMBER
  end

  def perform
    list_events_from_service
    push_response_events unless @response.items.empty?
    all_events
  end

  def list_events_from_service
    @response = @service.list_events(
      DEFAULT_CALENDAR_ID,
      max_results: @events_number,
      single_events: REQUEST_SINGLE_EVENTS,
      order_by: REQUEST_ORDER_BY,
      time_min: @start_date,
      time_max: @end_date
    )
  end

  def push_response_events
    @response.items.each do |event|
      all_events.push({ summary: event.summary,
                        description: event.description,
                        start_date: event.start.date_time,
                        end_date: event.end.date_time })
    end
  end

  def add_plus(string)
    string.tr(' ', '+')
  end
end
