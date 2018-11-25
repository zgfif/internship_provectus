# frozen_string_literal: true

class Event < ActiveRecord::Base
  include PriorityList

  enum event_type: %i[work personal entertainment other]

  enum creation_source: %i[local google]

  belongs_to :user, optional: true
  belongs_to :goal, optional: true

  has_many :tasks, dependent: :destroy

  validates :title, :priority, presence: true
  validates :title, length: { maximum: 50 }

  validates :description, length: { maximum: 255 }

  validates :location, format: {
    without: /[!@#$%^<>{}+=~&|*\[\]']/,
    message: "not allowed !@#$%^<>{}+=~&|*[]'"
  }

  validates_with ValidateDateService

  self.per_page = 10

  scope :standalone, -> { where(goal_id: nil) }
end
