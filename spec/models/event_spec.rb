# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Event model', type: :model do
  let(:user) { build :user }
  let(:goal) { build :goal, user: user }
  let(:event) { build :event, user: user, goal: goal }

  describe 'validating Event model with attributes' do
    it 'is valid with valid attributes' do
      expect(event).to be_valid
    end

    it 'is not valid without title' do
      event.title = nil
      expect(event).to_not be_valid
    end

    it 'is valid without description' do
      event.description = nil
      expect(event).to be_valid
    end

    it 'is valid without location' do
      event.location = nil
      expect(event).to be_valid
    end

    it 'is not valid without priority' do
      event.priority = nil
      expect(event).to_not be_valid
    end

    it 'is valid without event_type' do
      event.event_type = nil
      expect(event).to be_valid
    end

    it 'is not valid without start_date' do
      event.start_date = nil
      expect(event).to_not be_valid
    end

    it 'is not valid without end_date' do
      event.end_date = nil
      expect(event).to_not be_valid
    end
  end

  describe 'validating Event model with prohibited symbols in location' do
    it 'is not valid with !' do
      event.location = 'Zhuko!vskogo'
      expect(event).to_not be_valid
    end

    it 'is not valid with @' do
      event.location = 'Zhuko@vskogo'
      expect(event).to_not be_valid
    end
    it 'is not valid with #' do
      event.location = 'Zhuko#vskogo'
      expect(event).to_not be_valid
    end
    it 'is not valid with $' do
      event.location = 'Zhuko$vskogo'
      expect(event).to_not be_valid
    end
    it 'is not valid with %' do
      event.location = 'Zhuko%vskogo'
      expect(event).to_not be_valid
    end
    it 'is not valid with ^' do
      event.location = 'Zhuko^vskogo'
      expect(event).to_not be_valid
    end
    it 'is not valid with <' do
      event.location = 'Zhuko<vskogo'
      expect(event).to_not be_valid
    end
    it 'is not valid with >' do
      event.location = 'Zhuko>vskogo'
      expect(event).to_not be_valid
    end
    it 'is not valid with {' do
      event.location = 'Zhuko{vskogo'
      expect(event).to_not be_valid
    end
    it 'is not valid with }' do
      event.location = 'Zhuko}vskogo'
      expect(event).to_not be_valid
    end
    it 'is not valid with +' do
      event.location = 'Zhuko+vsogo'
      expect(event).to_not be_valid
    end
    it 'is not valid with =' do
      event.location = 'Zhuko=vskogo'
      expect(event).to_not be_valid
    end
    it 'is not valid with ~' do
      event.location = 'Zhuko~vsogo'
      expect(event).to_not be_valid
    end
    it 'is not valid with &' do
      event.location = 'Zhuko&vskogo'
      expect(event).to_not be_valid
    end
    it 'is not valid with |' do
      event.location = 'Zhuko|vskogo'
      expect(event).to_not be_valid
    end
    it 'is not valid with [' do
      event.location = 'Zhuko[vskogo'
      expect(event).to_not be_valid
    end
    it 'is not valid with ]' do
      event.location = 'Zhuko]vsogo'
      expect(event).to_not be_valid
    end
    it 'is not valid with \'' do
      event.location = 'Zhuko\'vsogo'
      expect(event).to_not be_valid
    end
  end
end
