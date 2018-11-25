# frozen_string_literal: true

module Search
  class DateConditionsService
    attr_accessor :attr, :data

    def initialize(attr, data)
      @attr = attr
      safe_params = data.permit(:gt, :lt, :gte, :lte, btw: %i[d1 d2])
      @data = safe_params.to_h
    end

    def self.call(attr, data)
      new(attr, data).perform
    end

    def perform
      [date_condtion, date_query]
    end

    def date_condtion
      "#{@attr} #{condition} ?"
    end

    def date_query
      if @data.key?('btw')
        array_for_between
      else
        date = @data.values.first.to_s
        add_plus(date)
      end
    end

    def condition
      case @data.keys.first
      when 'gt'
        '>'
      when 'lt'
        '<'
      when 'gte'
        '>='
      when 'lte'
        '<='
      else
        'BETWEEN ? AND'
      end
    end

    def array_for_between
      [].tap do |arr|
        @data.values[0].values.each do |v|
          date = v.to_s
          date = add_plus(date)
          arr << date
        end
      end
    end

    def add_plus(string)
      string.tr(' ', '+')
    end
  end
end
