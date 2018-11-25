# frozen_string_literal: true

class ValidateEnumService
  attr_accessor :model, :field, :value

  def initialize(model, field, value)
    @model = model
    @field = field
    @value = value
    @enum_range = EnumRangeService.call(@model, @field)
  end

  def self.call(model, field, value)
    new(model, field, value).perform
  end

  def perform
    raise ApplicationController::WrongEnum unless within_range?
  end

  def within_range?
    @enum_range.cover?(@value.to_i) if @value.present?
  end
end
