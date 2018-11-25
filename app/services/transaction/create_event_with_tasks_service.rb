# frozen_string_literal: true

module Transaction
  class CreateEventWithTasksService
    attr_accessor :current_user, :event_params, :tasks_params, :event

    extend Callable

    def initialize(current_user, event_params, tasks_params)
      @current_user = current_user
      @event_params = event_params
      @tasks_params = tasks_params
      @event = nil
    end

    def perform
      event_transaction
      @event
    end

    def event_transaction
      Event.transaction do
        @event = @current_user.events.create!(@event_params)
        task_transaction
      end
    end

    def task_transaction
      Task.transaction(requires_new: true) do
        @tasks_params.each do |task_params|
          @event.tasks.create!(task_params)
        end
      end
    end
  end
end
