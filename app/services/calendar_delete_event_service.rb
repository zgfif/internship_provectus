# frozen_string_literal: true

class CalendarDeleteEventService < CalendarService
  def self.call(current_user, event_id)
    new(current_user).perform(event_id)
  end

  def perform(event_id, calendar_id: DEFAULT_CALENDAR_ID)
    response = @service.list_events(calendar_id,
                                    max_results: DEFAULT_EVENTS_NUMBER,
                                    single_events: REQUEST_SINGLE_EVENTS,
                                    order_by: REQUEST_ORDER_BY)
    if response.items.any?
      if @service.get_event(calendar_id, event_id).status == 'confirmed'
        @service.delete_event(calendar_id, event_id)
      else
        Rails.logger.info "Couldn't find google calendar event: #{Time.now.iso8601}, #{calendar_id}, #{event_id}"
      end
    else
      Rails.logger.info "#{Time.now.iso8601} No events in your calendar"
    end
  end
end
