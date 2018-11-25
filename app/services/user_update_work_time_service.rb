# frozen_string_literal: true

class UserUpdateWorkTimeService
  attr_accessor :current_user, :params

  def self.call(current_user, params)
    new(current_user, params).perform
  end

  def initialize(current_user, params)
    @current_user = current_user
    @params = params
  end

  def perform
    return update_user_times if time_params_valid?
    :no_content
  end

  def update_user_times
    current_user.working_start_time = params[:work_start_time]
    current_user.working_end_time = params[:work_end_time]
    current_user.save ? :ok : :conflict
  end

  def time_params_valid?
    ValidateUserTimeParamsService.call(params)
  end
end
