# frozen_string_literal: true

module Enums
  class ValidateService
    attr_accessor :model, :field, :value

    def initialize(model, field, value)
      @model = model
      @field = field
      @value = value
    end

    def self.call(model, field, value)
      new(model, field, value).perform
    end

    def perform
      raise ApplicationController::WrongEnum unless correct_value?
    end

    def correct_value?
      in_range? if @value.present?
    end

    def enum_hash
      Enums::HashService.call(@model, @field)
    end

    def in_range?
      enum_hash.value?(@value) || enum_hash.key?(@value)
    end
  end
end
