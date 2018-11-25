# frozen_string_literal: true

class CalendarSyncEventsService < CalendarService
  attr_accessor :current_user, :events_available, :page_token

  extend Callable

  def initialize(current_user)
    super
    @current_user = current_user
    # TOTAL_EVENTS is constant from CalendarService, with value 2500
    @events_available = TOTAL_EVENTS
    @page_token = nil
  end

  def perform
    loop do
      @response = list_events_from_service
      @response.items ? perform_events_sync : log_no_upcoming_events
      break unless @page_token && @events_available.positive?
    end
  end

  def list_events_from_service
    # Get 250 or last (<250) events of calendar,
    # using page_token and requesting next_page_token
    @service.list_events(
      DEFAULT_CALENDAR_ID,
      max_results: [@events_available, DEFAULT_EVENTS_NUMBER].min,
      single_events: REQUEST_SINGLE_EVENTS,
      order_by: REQUEST_ORDER_BY,
      time_min: REQUEST_TIME_MIN,
      page_token: @page_token
    )
  end

  def perform_events_sync
    sync_response_events
    reduce_available_events!
    set_next_token!
  end

  def sync_response_events
    @response.items.each do |event|
      @response_event = event
      sync_response_event
    end
  end

  def reduce_available_events!
    # Reduce number of available events by number of passed events.
    @events_available -= @response.items.length
  end

  def set_next_token!
    @page_token = @response.next_page_token || nil
  end

  def sync_response_event
    @local_event = Event.find_by google_event_id: @response_event.id
    @local_event ? sync_google_event : create_google_event!
  end

  def sync_google_event
    if created_in_google?
      set_event_params_and_save!
    else
      log_trying_change_local_event
    end
  end

  def created_in_google?
    @local_event[:creation_source] == 'google'
  end

  def create_google_event!
    @local_event = @current_user.events.new
    @local_event[:creation_source] = 'google'
    @local_event[:google_event_id] = @response_event.id
    set_event_params_and_save!
  end

  def set_event_params_and_save!
    set_event_params
    @local_event.save! ? log_valid_params : log_invalid_params
  end

  def set_event_params
    @local_event[:title] = @response_event.summary
    @local_event[:location] = @response_event.location
    @local_event[:description] = @response_event.description
    @local_event[:start_date] = @response_event.start.date_time
    @local_event[:end_date] = @response_event.end.date_time
    @local_event[:priority] = 'normal'
  end

  def log_no_upcoming_events
    insert_log('failed', 'no upcoming events')
  end

  def log_trying_change_local_event
    insert_log('failed', 'trying change local event')
  end

  def log_invalid_params
    insert_log('failed', 'invalid event params')
  end

  def log_valid_params
    insert_log('success', 'valid event params')
  end

  def insert_log(status, reason)
    log_hash = log_params_to_hash(status, reason)
    SynchronizationInsertLogService.call(log_hash) if log_hash
  end

  def log_params_to_hash(status, reason)
    {
      user_id: @current_user.id.presence,
      calendar_id: DEFAULT_CALENDAR_ID.presence,
      event_id: @local_event.id.presence,
      status: status.presence,
      reason: reason.presence
    }
  end
end
