# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events', type: :request do
  create_valid_request_params = JSON.parse(File.read('public/json_examples/create_event_valid.json'))
  create_invalid_request_params = JSON.parse(File.read('public/json_examples/create_event_invalid.json'))
  update_valid_request_params = JSON.parse(File.read('public/json_examples/update_event_valid.json'))
  update_invalid_request_params = JSON.parse(File.read('public/json_examples/update_event_invalid.json'))

  let(:test_user) { create :user }
  let(:test_goal) { create :goal, user: test_user }
  let(:test_event) { create :event, user: test_user, goal: test_goal }

  before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(test_user) }
  before { allow_any_instance_of(EventsController).to receive(:goal).and_return(test_goal) }
  before { allow_any_instance_of(EventsController).to receive(:event).and_return(test_event) }

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      get goal_events_path(goal_id: test_goal.to_param)
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get goal_event_path(goal_id: test_goal.to_param, id: test_event.to_param)
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    before { allow(CalendarCreateEventService).to receive(:call).and_return("") }

    it 'with valid params renders a JSON response with the new event' do
      # p test_event
      local_params = create_valid_request_params
      post goal_events_path(goal_id: test_goal.to_param), params: local_params
      expect(response).to have_http_status(:created)
      expect(response.content_type).to eq('application/vnd.api+json')
    end

    it 'with invalid params renders a JSON response with errors for the new event' do
      local_params = create_invalid_request_params
      post goal_events_path(goal_id: test_goal.to_param), params: local_params
      expect(response).to have_http_status(:bad_request)
      expect(response.content_type).to eq('application/vnd.api+json')
    end
  end

  describe 'PATCH #update' do
    before { allow(CalendarUpdateEventService).to receive(:call).and_return(nil) }

    it 'renders a JSON response with the event' do
      local_params = update_valid_request_params
      patch goal_event_path(goal_id: test_goal.to_param, id: test_event.to_param), params: local_params
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/vnd.api+json')
    end

    it 'renders a JSON response with errors for the event' do
      local_params = update_invalid_request_params
      patch goal_event_path(goal_id: test_goal.to_param, id: test_event.to_param), params: local_params
      expect(response).to have_http_status(:conflict)
      expect(response.content_type).to eq('application/vnd.api+json')
    end
  end

  describe 'DELETE #destroy' do
    before { allow(CalendarDeleteEventService).to receive(:call).and_return(test_event) }
    it 'destroys the requested event' do
      delete event_path(id: test_event.to_param)
      expect(response).to have_http_status(:no_content)
    end
  end
end
