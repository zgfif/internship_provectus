# frozen_string_literal: true

class CalendarUpdateEventService < CalendarService
  def self.call(current_user, event)
    new(current_user).perform(event)
  end

  def perform(event, calendar_id: DEFAULT_CALENDAR_ID)
    google_event = @service.get_event(calendar_id, event[:google_event_id])
    if google_event
      google_event = update_columns!(google_event, event)
      status = @service.update_event(calendar_id, google_event.id, google_event)
      unless status.is_a? Google::Apis::CalendarV3::Event
        # TODO: handle into DB
        Rails.logger.error "Event not updated remotely: #{Time.now.iso8601}, #{calendar_id}, #{google_event.id} (#{status})"
      end
    else
      # TODO: handle into DB
      Rails.logger.info "Event not found: #{Time.now.iso8601}, #{calendar_id}, #{event[:google_event_id]}"
    end
  end

  def update_columns!(google_event, event)
    google_event.summary = event[:title]
    google_event.location = event[:location]
    google_event.description = event[:description]
    google_event.start.date_time = event[:start_date].in_time_zone('Kyiv').to_datetime
    google_event.end.date_time = event[:end_date].in_time_zone('Kyiv').to_datetime
    google_event
  end
end
