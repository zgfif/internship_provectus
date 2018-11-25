# frozen_string_literal: true

class EnumRangeService
  attr_accessor :model, :field

  def initialize(model, field)
    @model = model
    @field = field
  end

  def self.call(model, field)
    new(model, field).perform
  end

  def perform
    0..upper_index
  end

  def upper_index
    found_model.send(enum_method).values.last
  end

  def found_model
    @model.constantize
  end

  def enum_method
    @field.pluralize
  end
end
