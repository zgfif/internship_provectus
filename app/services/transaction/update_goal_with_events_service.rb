# frozen_string_literal: true

module Transaction
  class UpdateGoalWithEventsService
    attr_accessor :goal, :goal_params, :events_params, :event_ids, :necessary_event_ids

    extend Callable

    def initialize(goal, goal_transaction_params)
      @goal = goal
      @goal_params = goal_transaction_params[:attributes]
      @events_params = goal_transaction_params[:relationships][:event][:data]
      @events_ids = @goal.events.map(&:id)
      @necessary_event_ids = []
    end

    def perform
      goal_transaction
      @goal
    end

    def goal_transaction
      Goal.transaction do
        @goal.update!(@goal_params)
        events_transaction
      end
    end

    def events_transaction
      Event.transaction(requires_new: true) do
        @events_params.map { |event_param| update_or_create_event(event_param)}
        delete_unnecessary_events
      end
    end

    def update_or_create_event(event_param)
      if event_param[:id].present?
        Event.find(event_param[:id]).update!(event_param.except(:id))
        @necessary_event_ids << event_param[:id]
      else
        @goal.events.create!(event_param.except(:id))
      end
    end

    def delete_unnecessary_events
      unnecessary_events.map { |event_id| Event.destroy(event_id) }
    end

    def unnecessary_events
      # Select not updated events from all events of goal.
      @event_ids.select { |elem| !@necessary_event_ids.include?(elem) }
    end
  end
end
