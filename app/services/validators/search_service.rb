# frozen_string_literal: true

module Validators
  class SearchService
    def initialize(params)
      run_initialization(params) if params
    end

    def run_initialization(params)
      if params[:start_date]
        @params_start = params[:start_date].permit(:eq, :gt, :lt, :gte, :lte,
                                                   btw: %i[d1 d2])
      end
      if params[:end_date]
        @params_end = params[:end_date].permit(:eq, :gt, :lt, :gte, :lte,
                                               btw: %i[d1 d2])
      end
      @event_type = params.dig :event_type
      @priority = params.dig :priority
    end

    def self.call(params)
      new(params).validate
    end

    def validate
      validate_dates(united_array)
      validate_ints
    end

    def validate_dates(dates)
      dates.each do |date|
        Validators::SearchDateService.call(date)
      end
    end

    def united_array
      params_to_hashes
      array_for_dates(@params_start) + array_for_dates(@params_end)
    end

    def params_to_hashes
      @params_start = @params_start.to_h
      @params_end = @params_end.to_h
    end

    def array_for_dates(hash)
      [].tap do |array|
        hash.values.each do |v|
          array << if v.is_a? Hash
                     v.values[0]
                   else
                     v
                   end
        end
      end
    end

    def validate_ints
      Validators::SearchIntService.call(@priority, 2) if @priority
      Validators::SearchIntService.call(@event_type, 3) if @event_type
    end
  end
end
