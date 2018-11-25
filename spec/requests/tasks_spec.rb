# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  create_valid_request_params = JSON.parse(File.read('public/json_examples/create_task_valid.json'))
  create_invalid_request_params = JSON.parse(File.read('public/json_examples/create_task_invalid.json'))
  update_valid_request_params = JSON.parse(File.read('public/json_examples/update_task_valid.json'))
  update_invalid_request_params = JSON.parse(File.read('public/json_examples/update_task_invalid.json'))

  let(:test_user) { create :user }
  let(:test_goal) { create :goal, user: test_user }
  let(:test_event) { create :event, goal: test_goal }
  let(:test_task) { create :task, event: test_event }

  before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(test_user) }
  before { allow_any_instance_of(TasksController).to receive(:goal).and_return(test_goal) }
  before { allow_any_instance_of(TasksController).to receive(:event).and_return(test_event) }
  before { allow_any_instance_of(TasksController).to receive(:task).and_return(test_task) }

  let(:valid_session) { {} }

  describe 'GET /event/event_id/tasks' do
    it 'returns a success response' do
      get goal_event_tasks_path(goal_id: test_goal.to_param, event_id: test_event.to_param)
      expect(response).to be_successful
    end
  end

  describe 'GET /event/event_id/tasks/task_id' do
    it 'returns a success response' do
      get goal_event_task_path(goal_id: test_goal.to_param, event_id: test_event.to_param, id: test_task.to_param)
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'with valid params renders a JSON response with the new task' do
      local_params = create_valid_request_params
      post goal_event_tasks_path(goal_id: test_goal.to_param, event_id: test_event.to_param), params: local_params, as: :json
      expect(response).to have_http_status(:created)
      expect(response.content_type).to eq('application/vnd.api+json')
    end

    it 'with invalid params renders a JSON response with errors' do
      local_params = create_invalid_request_params
      post goal_event_tasks_path(goal_id: test_goal.to_param, event_id: test_event.to_param), params: local_params, as: :json
      expect(response).to have_http_status(:conflict)
      expect(response.content_type).to eq('application/vnd.api+json')
    end
  end

  describe 'PATCH #update' do
    it 'with valid params renders a JSON response with the task' do
      local_params = update_valid_request_params
      patch goal_event_task_path(goal_id: test_goal.to_param, event_id: test_event.to_param, id: test_task.to_param), params: local_params, as: :json
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/vnd.api+json')
    end

    it 'with invalid params renders a JSON response with errors for the task' do
      local_params = update_invalid_request_params
      put goal_event_task_path(goal_id: test_goal.to_param, event_id: test_event.to_param, id: test_task.to_param), params: local_params, as: :json
      expect(response).to have_http_status(:conflict)
      expect(response.content_type).to eq('application/vnd.api+json')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys requested task' do
      delete goal_event_task_path(goal_id: test_goal.to_param, event_id: test_event.to_param, id: test_task.to_param)
      expect(response).to have_http_status(:no_content)
    end
  end
end
