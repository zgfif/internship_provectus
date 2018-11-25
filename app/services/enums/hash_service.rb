# frozen_string_literal: true

module Enums
  class HashService
    attr_accessor :model, :field

    def initialize(model, field)
      @model = model
      @field = field
    end

    def self.call(model, field)
      new(model, field).perform
    end

    def perform
      found_model.send(enum_method)
    end

    def found_model
      @model.constantize
    end

    def enum_method
      @field.pluralize
    end
  end
end
