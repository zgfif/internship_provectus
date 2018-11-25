# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/events/1/tasks').to route_to('tasks#index', event_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/events/1/tasks/1').to route_to('tasks#show', event_id: '1', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/events/1/tasks').to route_to('tasks#create', event_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/events/1/tasks/1').to route_to('tasks#update', event_id: '1', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/events/1/tasks/1').to route_to('tasks#update', event_id: '1', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/events/1/tasks/1').to route_to('tasks#destroy', event_id: '1', id: '1')
    end
  end
end
