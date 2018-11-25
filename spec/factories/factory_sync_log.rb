# frozen_string_literal: true

FactoryBot.define do
  factory :sync_log, class: SyncLog do
    id { SecureRandom.uuid }
    time { '2018-10-09 15:57:53' }
    calendar_id { SecureRandom.uuid.to_s }
    status { 'success' }
    reason { 'valid event params' }
  end
end
