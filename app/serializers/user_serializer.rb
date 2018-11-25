# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id

  has_many :goals
  has_many :events
end
