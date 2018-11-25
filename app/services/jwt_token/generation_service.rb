# frozen_string_literal: true

module JwtToken
  class GenerationService
    attr_accessor :user

    def self.call(user)
      new(user).perform
    end

    def initialize(user)
      @user = user
    end

    def perform
      JwtService.encode(payload)
    end

    def payload
      { user_id: @user.id, created: Time.now }
    end
  end
end
