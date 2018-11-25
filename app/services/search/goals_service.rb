# frozen_string_literal: true

module Search
  class GoalsService
    INPUT_TYPES = [
      STRING_TYPE = :string,
      DATETIME_TYPE = :datetime,
      INT_TYPE = :integer
    ].freeze

    attr_accessor :goals, :params

    def self.call(goals, params)
      new(goals, params).perform
    end

    def initialize(goals, params)
      @goals = goals
      @params = params[:q]
    end

    def perform
      filter_goals if @params
      @goals
    end

    def filter_goals
      query_hash = Search::BuildHashService.call(@params, filtering_keys)
      # creates hash of params data. It will be used to build the search args
      array = Search::BuildArrayOfArgsService.call(query_hash)
      @goals = @goals.where(*array)
    end

    def filtering_keys
      {
        title: STRING_TYPE,
        start_date: DATETIME_TYPE,
        end_date: DATETIME_TYPE,
        goal_type: INT_TYPE
      }
    end
  end
end
