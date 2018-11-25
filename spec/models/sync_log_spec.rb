# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'SyncLog model', type: :model do
  let(:user) { build :user }
  let(:sync_log) { build :sync_log, user: user }

  describe 'validating SyncLog model with attributes' do
    it 'is valid with valid attributes' do
      expect(sync_log).to be_valid
    end

    it 'is valid without time' do
      sync_log.time = nil
      expect(sync_log).to be_valid
    end

    it 'is valid without calendar_id' do
      sync_log.calendar_id = nil
      expect(sync_log).to be_valid
    end

    it 'is valid without status' do
      sync_log.status = nil
      expect(sync_log).to be_valid
    end

    it 'is valid without reason' do
      sync_log.reason = nil
      expect(sync_log).to be_valid
    end

    it 'is not valid without user' do
      sync_log.user = nil
      expect(sync_log).to_not be_valid
    end
  end
end
