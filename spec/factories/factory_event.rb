# frozen_string_literal: true

FactoryBot.define do
  factory :event, class: Event do
    id { SecureRandom.uuid }
    title { 'Hello Kitten' }
    description { 'Test Event' }
    location { 'Dreamland, 2' }
    priority { 'low' }
    event_type { 'personal' }
    start_date { '2018-09-18T13:05:17+03:00' }
    end_date { '2018-09-18T14:05:17+03:00' }
  end
end
