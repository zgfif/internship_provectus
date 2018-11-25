# frozen_string_literal: true

class Goal < ApplicationRecord
  belongs_to :user

  has_many :events, dependent: :destroy

  enum goal_type: %i[work personal entertainment other]

  validates :title, :goal_type, :s, :m, :a, :r, :t, presence: true

  validates_with ValidateDateService

  validates :title, length: { maximum: 50 }

  validates :description, length: { maximum: 255 }

  self.per_page = 10
end
