# frozen_string_literal: true

class ValidateDateService < ActiveModel::Validator
  def validate(record)
    if record.end_date && record.start_date
      if record.end_date <= record.start_date
        record.errors[:error] << 'start_date must be earlier end_date'
      end
    else
      record.errors[:error] << 'start_date and end_date params must be present'
    end
  end
end
