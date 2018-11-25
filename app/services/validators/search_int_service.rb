# frozen_string_literal: true

module Validators
  class SearchIntService
    def initialize(int, upper)
      @int = int
      @upper = upper.to_i
    end

    def self.call(int, upper)
      new(int, upper).validate
    end

    def validate
      run_validation if @int && @upper
    end

    def run_validation
      raise exception unless correct_int?
    end

    def correct_int?
      number? && in_range?
    end

    def number?
      CheckerService.call(@int).numeric?
    end

    def in_range?
      (0..@upper).cover?(@int.to_i)
    end

    def exception
      ApplicationController::BadRequest
    end
  end
end
