# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :check_task_enum, only: %i[create update]

  def index
    paginate_and_run
  end

  def show
    render json: task, status: :ok
  end

  def create
    @task = event.tasks.new(task_params)
    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :conflict
    end
  end

  def update
    if task.update(task_params)
      render json: task, status: :ok
    else
      render json: task.errors, status: :conflict
    end
  end

  def destroy
    if task.destroy
      render json: task, status: :no_content
    else
      render json: task.errors, status: :accepted
    end
  end

  private

  def goal_id?
    params[:goal_id].present?
  end

  def goal
    @goal ||= current_user.goals.find(params[:goal_id])
  end

  def event
    @event ||= if goal_id?
                 goal.events.find(params[:event_id])
               else
                 current_user.events.find(params[:event_id])
               end
  end

  def tasks
    @tasks ||= event.tasks.all
  end

  def task
    @task ||= event.tasks.find(params[:id])
  end

  def task_params
    params.permit(
      [data:
        [
          :type,
          attributes:
          %i[title description status priority]
        ]]
    )[:data][:attributes]
  end

  def check_task_enum
    check_enum('status', task_params[:status])
  end

  def paginate_and_run
    render json: paginate(tasks)
  end
end
