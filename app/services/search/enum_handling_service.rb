# frozen_string_literal: true

module Search
  class EnumHandlingService
    attr_accessor :model, :field, :value

    extend Callable

    def initialize(model, field, value)
      @model = model
      @field = field
      @value = value
    end

    def perform
      hash = Enums::HashService.call(@model, @field)
      process_enum(hash)
    end

    def process_enum(hash)
      if hash.key? @value
        hash[@value]
      elsif hash.value?(@value.to_i) && real_num?
        @value
      else
        raise ApplicationController::WrongEnum
      end
    end

    def real_num?
      CheckerService.call(@value).numeric?
    end
  end
end
