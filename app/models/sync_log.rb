# frozen_string_literal: true

class SyncLog < ApplicationRecord
  belongs_to :user

  enum status: %i[failed success]
end
