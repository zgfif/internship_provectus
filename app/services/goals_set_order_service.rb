# frozen_string_literal: true

class GoalsSetOrderService
  attr_accessor :goals, :params

  def self.call(goals, params)
    new(goals, params).fetch
  end

  def initialize(goals, params)
    @goals = goals
    @params = params
  end

  def fetch
    set_goals_order! if sort_params_present?
    @goals
  end

  def set_goals_order!
    @goals = @goals.order("#{@params[:attribute]} #{@params[:order]}")
  end

  def sort_params_present?
    @params[:attribute] && @params[:order]
  end
end
