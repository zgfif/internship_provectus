# frozen_string_literal: true

module Transaction
  class CreateGoalWithEventsService
    attr_accessor :current_user, :goals_params, :events_params, :goal

    extend Callable

    def initialize(current_user, goal_transaction_params)
      @current_user = current_user
      @goal_params = goal_transaction_params[:attributes]
      @events_params = goal_transaction_params[:relationships][:event][:data]
      @goal = nil
    end

    def perform
      goal_transaction
      @goal
    end

    def goal_transaction
      Goal.transaction do
        @goal = @current_user.goals.create!(@goal_params)
        event_transaction
      end
    end

    def event_transaction
      Event.transaction(requires_new: true) do
        @events_params.each do |event_params|
          @goal.events.create!(event_params)
        end
      end
    end
  end
end
