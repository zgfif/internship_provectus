# frozen_string_literal: true

class GoalsUpdateRelationsService
  attr_reader :goal, :params

  extend Callable

  def initialize(goal, params)
    @params = params
    @goal = goal
  end

  def perform
    goal.transaction do
      params.map { |event| Event.find(event[:id]).update(goal_id: goal.id) }
    end
  end
end

