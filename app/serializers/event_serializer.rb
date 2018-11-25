# frozen_string_literal: true

class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :location, :priority, :event_type,
             :start_date, :end_date, :google_event_id, :creation_source,
             :tasks_count, :goal_id

  belongs_to :goal
  belongs_to :user

  has_many :tasks

  def tasks_count
    {
      total: object.tasks.count,
      completed: object.tasks.completed.count
    }
  end
end
