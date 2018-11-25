# frozen_string_literal: true

module Validators
  class SearchDateService
    def initialize(str)
      @str = str
    end

    def self.call(str)
      new(str).validate
    end

    def validate
      run_validation if @str
    end

    def run_validation
      date_format
      date_numbers
    end

    def correct_format_date?
      full_datetime || date_minutes || date_hours || only_date || with_timezone
    end

    def date_format
      raise exception unless correct_format_date?
    end

    def date_numbers
      DateTime.parse @str
    rescue ArgumentError
      raise exception
    end

    def exception
      ApplicationController::BadRequest
    end

    def with_timezone
      /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.000+03:00/ =~ @str
    end

    def full_datetime
      /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/ =~ @str
    end

    def date_minutes
      /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$/ =~ @str
    end

    def date_hours
      /^\d{4}-\d{2}-\d{2}T\d{2}:$/ =~ @str
    end

    def only_date
      /^\d{4}-\d{2}-\d{2}$/ =~ @str
    end
  end
end
