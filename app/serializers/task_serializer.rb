# frozen_string_literal: true

class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :status

  belongs_to :event
end
