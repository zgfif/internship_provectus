# frozen_string_literal: true

module Params
  class PaginationService
    DEFAULT_NUMBER = 1
    DEFAULT_SIZE = 10

    def initialize(params)
      @params = params
      @number = params.dig :page, :number
      @size = params.dig :page, :size
    end

    def self.call(params)
      new(params).perform
    end

    def perform
      @params[:page].tap do |params|
        params[:number] = process_num if @number
        params[:size] = process_size if @size
      end
    end

    def process_num
      real_num?(@number) ? @number : DEFAULT_NUMBER
    end

    def process_size
      real_num?(@size) ? @size : DEFAULT_SIZE
    end

    def real_num?(num)
      CheckerService.call(num).numeric?
    end
  end
end
