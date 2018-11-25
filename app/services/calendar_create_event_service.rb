# frozen_string_literal: true

class CalendarCreateEventService < CalendarService
  def self.call(current_user, event_params)
    new(current_user).perform(event_params)
  end

  def perform(event_params, calendar_id: DEFAULT_CALENDAR_ID)
    # Creating event based on arguments data
    event = Google::Apis::CalendarV3::Event.new(
      summary: event_params[:title],
      location: event_params[:location],
      description: event_params[:description],
      start: {
        date_time: event_params[:start_date]
      },
      end: {
        date_time: event_params[:end_date]
      }
    )
    status = @service.insert_event(calendar_id, event)
    if status.is_a? Google::Apis::CalendarV3::Event
      status.id
    else
      Rails.logger.error "Event not created: #{Time.now.iso8601}, #{calendar_id}, #{event.id} (#{status})"
      nil
    end
  end
end
