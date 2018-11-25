# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :goals, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :sync_logs, dependent: :destroy

  enum default_events_type: %i[work personal entertainment other]
  enum default_events_priority: %i[high normal low]
end
