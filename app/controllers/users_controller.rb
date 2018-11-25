# frozen_string_literal: true

class UsersController < ApplicationController
  def me
    render json: current_user, status: :ok
  end

  def update_work_time
    render status: UserUpdateWorkTimeService.call(current_user, params)
  end
  
  def my_data
    render json: current_user.attributes, status: :ok 
  end  

  def update_events_attributes
    render status: UserUpdateEventsAttributesService.call(current_user, params)
  end

  def update_sync_enabled
    render status: UserUpdateSyncEnabledService.call(current_user, params)
  end
end
