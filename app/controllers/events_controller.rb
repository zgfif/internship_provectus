# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :check_dates, :check_event_enums, only: %i[create update]

  def index
    paginate_and_run
  end

  def show
    render json: event, status: :ok
  end

  def show_many
    render json: EventsShowManyService.call(show_many_params), status: :ok
  end

  def create
    @event = goal_id? ? goal.events.new(event_params) : current_user.events.new(event_params)

    @event[:user_id] = goal[:user_id] if goal_id?

    if @event.save
      add_to_google_calendar if user_sync_enabled?
      render json: @event, status: :created
    else
      render json: @event.errors, status: :conflict
    end
  end

  def create_global
    render json: create_event_by_transaction, status: :ok
  end

  def update
    if event.update(event_params)
      CalendarUpdateEventService.call(current_user, event) if user_sync_enabled?
      render json: event, status: :ok
    else
      render json: event.errors, status: :conflict
    end
  end

  def update_global
    render json: update_event_by_transaction, status: :ok
  end

  def update_event_by_transaction
    check_dependent_tasks_enum
    @event = Transaction::UpdateEventWithTasksService.call(event, event_params, tasks_params)
    @event[:goal_id] = params[:goal_id] if goal_id?
    CalendarUpdateEventService.call(current_user, event) if user_sync_enabled?
    event.save
    event
  end

  def destroy
    CalendarDeleteEventService.call(current_user, event[:google_event_id]) if user_sync_enabled?
    if event.destroy
      render json: event, status: :no_content
    else
      render json: event.errors, status: :accepted
    end
  end

  def sync
    render head: CalendarSyncEventsService.delay.call(current_user)
  end

  def sync_log_history
    return head :no_content unless sync_logs
    render json: sync_logs, status: :ok
  end

  def get_old_events
    render json: old_events, status: old_events ? :ok : :conflict
  end

  def old_events
    @old_events ||= CalendarReadOldEventsService.call(current_user, params)
  end

  private

  def user_sync_enabled?
    current_user[:sync_enabled]
  end

  def goal_id?
    params[:goal_id].present?
  end

  def goal
    @goal ||= current_user.goals.find(params[:goal_id])
  end

  def event
    @event ||= goal_id? ? goal.events.find(params[:id]) : current_user.events.find(params[:id])
  end

  def events
    @events ||= goal_id? ? goal.events : current_user_events
  end

  def sync_logs
    @sync_logs ||= current_user.sync_logs
  end

  def filtered_events
    @filtered_events ||= Search::EventsService.call(events, params)
  end

  def paginate_and_run
    render json: paginate(EventsSetOrderService.call(filtered_events, params)), meta: metadata
  end

  def current_user_events
    return current_user.events.standalone if params[:standalone].present?
    current_user.events
  end

  def event_params
    @events_params ||= event_transaction_params[:attributes]
  end

  def tasks_params
    @tasks_params ||= event_transaction_params[:relationships][:task][:data]
  end

  def event_transaction_params
    @event_transaction_params ||= params.permit(
      [data:
        [
          :type,
          attributes:
            %i[title description location priority event_type start_date end_date goal_id],
          relationships:
          [
            task:
            [
              data:
                %i[id title status]
      ]]]]
    )[:data]
    raise ActionController::BadRequest if @event_transaction_params.nil?
    @event_transaction_params
  end

  def show_many_params
    @show_many_params ||= params.permit(
      [
        data: [
          :id
        ]
      ]
    )[:data]
  end

  def check_dates
    ValidateFormatDateService.call(event_params)
  end

  def check_event_enums
    check_enum('event_type', event_params[:event_type])
    check_enum('priority', event_params[:priority])
  end

  def check_dependent_tasks_enum
    tasks_params.each do |task_param|
      Enums::ValidateService.call('Task', 'status', task_param[:status])
    end
  end

  def add_to_google_calendar
    @event[:google_event_id] = CalendarCreateEventService.call(current_user, event_params)
    @event.save
  end

  def create_event_by_transaction
    check_dependent_tasks_enum
    @event = Transaction::CreateEventWithTasksService.call(current_user, event_params, tasks_params)
    @event[:goal_id] = params[:goal_id] if goal_id?
    add_to_google_calendar if user_sync_enabled?
    @event.save
    @event
  end

  def metadata
    @metadata ||= { events_count: filtered_events.count }
  end
end
