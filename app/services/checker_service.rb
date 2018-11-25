# frozen_string_literal: true

class CheckerService
  def initialize(value)
    @value = value
  end

  def self.call(value)
    new(value)
  end

  def numeric?
    @value !~ /\D/
  end
end
