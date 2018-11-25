# frozen_string_literal: true

class SynchronizationInsertLogService
  attr_reader :sync_log_params

  SYNC_LOG_ATTRIBUTES = %i[user_id calendar_id event_id status reason].freeze

  extend Callable

  def initialize(params)
    @sync_log_params = params.slice(*SYNC_LOG_ATTRIBUTES)
  end

  def perform
    SyncLog.create(sync_log_params.merge(time: Time.now.utc))
  end
end
