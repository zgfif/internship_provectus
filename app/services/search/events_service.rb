# frozen_string_literal: true

module Search
  class EventsService
    INPUT_TYPES = [
      STRING_TYPE = :string,
      DATETIME_TYPE = :datetime,
      INT_TYPE = :integer
    ].freeze

    attr_accessor :events, :params

    def self.call(events, params)
      new(events, params).perform
    end

    def initialize(events, params)
      @events = events
      @params = params[:q]
    end

    def perform
      validate_params
      filter_events if @params
      @events
    end

    def filter_events
      query_hash = Search::BuildHashService.call(@params, filtering_keys)
      # creates hash of params data. It will be used to build the search args
      array = Search::BuildArrayOfArgsService.call(query_hash)
      @events = @events.where(*array)
    end

    def filtering_keys
      {
        title: STRING_TYPE, description: STRING_TYPE,
        location: STRING_TYPE, start_date: DATETIME_TYPE,
        end_date: DATETIME_TYPE, priority: INT_TYPE,
        google_event_id: STRING_TYPE, event_type: INT_TYPE,
        goal_type: INT_TYPE
      }
    end

    def validate_params
      Validators::SearchService.call(@params)
    end
  end
end
