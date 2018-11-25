# frozen_string_literal: true

FactoryBot.define do
  factory :goal, class: Goal do
    id { SecureRandom.uuid }
    title { 'Learn French' }
    description { 'Test Goal' }
    picture { 'home/provance.jpg' }
    start_date { '2018-09-14 19:45:12' }
    end_date { '2018-09-14 20:45:12' }
    goal_type { 0 }
    s { 'MyText' }
    m { 'MyText' }
    a { 'MyText' }
    r { 'MyText' }
    t { 'MyText' }
  end
end
