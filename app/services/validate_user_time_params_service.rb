# frozen_string_literal: true

class ValidateUserTimeParamsService
  attr_accessor :start_time, :end_time, :pattern

  def self.call(params)
    new(params).perform
  end

  def initialize(params)
    @start_time = params[:work_start_time]
    @end_time = params[:work_end_time]
    @pattern = /\d{2}:\d{2}:\d{2}/
  end

  def perform
    return time_params_valid_format? if time_params_present?
    false
  end

  def time_params_present?
    start_time.presence && end_time.presence
  end

  def time_params_valid_format?
    pattern.match?(start_time) && pattern.match?(end_time)
  end
end
