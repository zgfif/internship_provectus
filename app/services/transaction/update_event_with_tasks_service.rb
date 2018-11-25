# frozen_string_literal: true

module Transaction
  class UpdateEventWithTasksService
    attr_accessor :event, :event_params, :tasks_params, :task_ids, :necessary_task_ids

    extend Callable

    def initialize(event, event_params, tasks_params)
      @event = event
      @event_params = event_params
      @tasks_params = tasks_params
      @task_ids = @event.tasks.map(&:id)
      @necessary_task_ids = []
    end

    def perform
      event_transaction
      @event
    end

    def event_transaction
      Event.transaction do
        @event.update!(@event_params)
        tasks_transaction
      end
    end

    def tasks_transaction
      Task.transaction(requires_new: true) do
        @tasks_params.map { |task_param| update_or_create_task(task_param)}
        delete_unnecessary_tasks
      end
    end

    def update_or_create_task(task_param)
      if task_param[:id].present?
        Task.find(task_param[:id]).update!(task_param.except(:id))
        @necessary_task_ids << task_param[:id]
      else
        @event.tasks.create!(task_param.except(:id))
      end
    end

    def delete_unnecessary_tasks
      unnecessary_tasks.map { |task_id| Task.destroy(task_id) }
    end

    def unnecessary_tasks
      # Select not updated tasks from all tasks of event.
      @task_ids.select { |elem| !@necessary_task_ids.include?(elem) }
    end
  end
end
