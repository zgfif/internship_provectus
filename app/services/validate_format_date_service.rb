# frozen_string_literal: true

class ValidateFormatDateService
  def initialize(params)
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  end

  def self.call(params)
    new(params).validate
  end

  def validate
    if incorrect_date?(@start_date) || incorrect_date?(@end_date)
      raise ApplicationController::WrongDate
    end
    validate_date_numbers(@start_date)
    validate_date_numbers(@end_date)
  end

  def incorrect_date?(date)
    true unless /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/ =~ date
  end

  def raise_wrong
    raise ApplicationController::WrongDate
  end

  def validate_date_numbers(date)
    DateTime.parse date rescue raise ApplicationController::WrongDate
  end
end
