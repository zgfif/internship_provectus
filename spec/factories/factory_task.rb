# frozen_string_literal: true

FactoryBot.define do
  factory :task, class: Task do
    id { SecureRandom.uuid }
    title { 'CRUD' }
    status { 0 }
  end
end
