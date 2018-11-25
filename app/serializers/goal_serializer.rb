# frozen_string_literal: true

class GoalSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :picture, :start_date, :end_date, :goal_type, :s, :m, :a, :r, :t

  belongs_to :user

  has_many :events
end
