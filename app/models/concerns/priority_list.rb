# frozen_string_literal: true

module PriorityList
  extend ActiveSupport::Concern
  included do
    enum priority: %i[high normal low]
  end
end
