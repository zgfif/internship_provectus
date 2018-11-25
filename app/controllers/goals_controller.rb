# frozen_string_literal: true

class GoalsController < ApplicationController
  before_action :check_dates, only: %i[create update]

  def index
    paginate_and_run
  end

  def show
    render json: goal, status: :ok
  end

  def create
    @goal = current_user.goals.new(goal_params)

    if @goal.save
      render json: @goal, status: :created
    else
      render json: @goal.errors, status: :conflict
    end
  end

  def create_global
    render json: create_goal_by_transaction, status: :ok
  end

  def create_assigned
    @goal = current_user.goals.new(goal_transaction_params[:attributes])
    if @goal.save
      GoalsUpdateRelationsService.call(@goal, goal_transaction_params[:relationships][:event][:data])
      render json: @goal, status: :ok
    else
      render json: @goal.errors, status: :conflict
    end
  end

  def create_goal_by_transaction
    check_dependent_events_enum
    Transaction::CreateGoalWithEventsService.call(current_user, goal_transaction_params)
  end

  def update
    if goal.update(goal_params)
      render json: goal, status: :ok
    else
      render json: goal.errors, status: :conflict
    end
  end

  def update_global
    render json: update_goal_by_transaction, status: :ok
  end

  def update_assigned
    if goal.update(goal_transaction_params[:attributes])
      goal.events.map { |event| event.update(goal_id: nil) }
      GoalsUpdateRelationsService.call(goal, goal_transaction_params[:relationships][:event][:data])
      render json: goal, status: :ok
    else
      render json: goal.errors, status: :conflict
    end
  end

  def update_goal_by_transaction
    check_dependent_events_enum
    Transaction::UpdateGoalWithEventsService.call(goal, goal_transaction_params)
  end

  def check_dependent_events_enum
    events_params = goal_transaction_params[:relationships][:event][:data]
    events_params.each do |events_param|
      Enums::ValidateService.call('Event', 'event_type', events_param[:event_type])
      Enums::ValidateService.call('Event', 'priority', events_param[:priority])
    end
  end

  def update_relations
    render head: GoalsUpdateRelationsService.call(goal, goal_relations_params)
  end

  def destroy
    if goal.destroy
      render json: goal, status: :no_content
    else
      render json: goal.errors, status: :accepted
    end
  end

  private

  def goal
    @goal ||= current_user.goals.find(params[:id])
  end

  def goals
    @goals ||= current_user.goals
  end

  def filtered_goals
    @filtered_goals ||= Search::GoalsService.call(goals, params)
  end

  def goal_params
    params.permit(
      [
        data: [
          :type,
          attributes: %i[
            title description picture start_date end_date goal_type s m a r t
          ]
        ]
      ]
    )[:data][:attributes]
  end

  def goal_relations_params
    params.permit(
      [
        data: [
          :id
        ]
      ]
    )[:data]
  end

  def goal_transaction_params
    @goal_transaction_params ||= params.permit(
      [data:
        [
          :type,
          :id,
          attributes:
            %i[title description picture start_date end_date goal_type s m a r t],
          relationships:
          [
            event:
            [
              data:
                %i[id title description location priority event_type start_date end_date goal_id]
      ]]]]
    )[:data]
    raise ActionController::BadRequest if @goal_transaction_params.nil?
    @goal_transaction_params
  end

  def check_dates
    ValidateFormatDateService.new(goal_params).validate
  end

  def paginate_and_run
    check_page_params if params[:page].present?
    render json: paginate(GoalsSetOrderService.call(filtered_goals, params)),
           meta: metadata
  end

  def metadata
    @metadata ||= { goal_count: filtered_goals.count }
  end

  def check_page_params
    Params::PaginationService.call(params)
  end
end
