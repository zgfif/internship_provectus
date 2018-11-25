# frozen_string_literal: true

class EventsShowManyService
  attr_accessor :events_params, :result_hash

  extend Callable

  def initialize(events_params)
    @events_params = events_params
    @result_hash = []
  end

  def perform
    events_params.each do |event_param|
      event = Event.find(event_param[:id])
      result_hash.push({id: event_param[:id], title: event.title})
    end
    result_hash
  end
end
