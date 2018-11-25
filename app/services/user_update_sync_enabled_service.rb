# frozen_string_literal: true

class UserUpdateSyncEnabledService
  attr_reader :current_user, :sync_enabled

  def self.call(current_user, params)
    new(current_user, params).perform
  end

  def initialize(current_user, params)
    @current_user = current_user
    @sync_enabled = convert_to_boolean(params[:sync_enabled])
  end

  def perform
    current_user.sync_enabled = sync_enabled
    current_user.save! ? :ok : :conflict
  end

  def convert_to_boolean(value)
    value == 'true' ? true : false
  end
end
