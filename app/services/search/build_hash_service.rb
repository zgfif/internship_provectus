# frozen_string_literal: true

module Search
  class BuildHashService < EventsService
    MODEL = 'Goal'
    ENUM = 'goal_type'

    attr_accessor :params, :allowed_keys, :hash

    def self.call(params, filters)
      new(params, filters).perform
    end

    def initialize(params, filters)
      @params = params
      @filters = filters
      @hash = {}
    end

    def perform
      @params.each do |field, value|
        if @filters.key?(field.to_sym)
          filter_type = @filters[field.to_sym]
          @hash[field] = array_for_key(field, filter_type, value)
        end
      end
      @hash
    end

    def array_for_key(field, filter_type, value)
      case filter_type
      when STRING_TYPE
        process_string(field, value)
      when DATETIME_TYPE
        Search::DateConditionsService.call(field, value)
      else
        if field == ENUM
          value = Search::EnumHandlingService.call(MODEL, field, value)
        end
        process_int(field, value)
      end
    end

    def process_string(field, value)
      ["#{field} ILIKE ?", "%#{value}%"]
    end

    def process_int(field, value)
      ["#{field} = ?", value]
    end
  end
end
