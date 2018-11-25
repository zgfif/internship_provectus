# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Goal model', type: :model do
  let(:user) { build :user }
  let(:goal) { build :goal, user: user }
  describe 'validating Goal model with attributes' do
    it 'is valid with valid attributes' do
      expect(goal).to be_valid
    end

    it 'is not valid without title' do
      goal.title = nil
      expect(goal).to_not be_valid
    end

    it 'is valid without description' do
      goal.description = nil
      expect(goal).to be_valid
    end

    it 'is not valid without start_date' do
      goal.start_date = nil
      expect(goal).to_not be_valid
    end

    it 'is not valid without end_date' do
      goal.end_date = nil
      expect(goal).to_not be_valid
    end

    it 'is not valid without goal_type' do
      goal.goal_type = nil
      expect(goal).to_not be_valid
    end

    it 'is valid without picture' do
      goal.picture = nil
      expect(goal).to be_valid
    end

    it 'is not valid without s' do
      goal.s = nil
      expect(goal).to_not be_valid
    end
    it 'is not valid without m' do
      goal.m = nil
      expect(goal).to_not be_valid
    end
    it 'is not valid without a' do
      goal.a = nil
      expect(goal).to_not be_valid
    end
    it 'is not valid without r' do
      goal.r = nil
      expect(goal).to_not be_valid
    end
    it 'is not valid without t' do
      goal.t = nil
      expect(goal).to_not be_valid
    end
  end
end
