# frozen_string_literal: true

module Search
  class BuildArrayOfArgsService
    # result will be the array of args for 'where' method
    attr_accessor :query_hash

    def self.call(query_hash)
      new(query_hash).perform
    end

    def initialize(query_hash)
      @query_hash = query_hash
    end

    def perform
      final_args_array(first_arg, last_args)
    end

    def first_arg
      (+'').tap do |str|
        @query_hash.each_value do |value|
          str << add_segment(value)
        end
      end
    end

    def add_segment(value)
      if element(value) == last_element
        last_segment(value)
      else
        segment(value)
      end
    end

    def element(value)
      value[0]
    end

    def last_element
      @query_hash.values.last[0]
    end

    def last_segment(value)
      value[0].to_s
    end

    def segment(value)
      "#{value[0]} AND "
    end

    def last_args
      [].tap do |array|
        @query_hash.each_value do |value|
          if args_for_between?(value)
            array.push(value[1][0], value[1][1])
          else
            array << value[1]
          end
        end
      end
    end

    def args_for_between?(value)
      value[1].is_a?(Array)
    end

    def final_args_array(arg1, args)
      [].tap do |array|
        array << arg1
        array.concat(args)
      end
    end
  end
end
