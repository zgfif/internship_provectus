# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Goals', type: :request do
  create_valid_request_params = JSON.parse(File.read('public/json_examples/create_goal_valid.json'))
  create_invalid_request_params = JSON.parse(File.read('public/json_examples/create_goal_invalid.json'))
  update_valid_request_params = JSON.parse(File.read('public/json_examples/update_goal_valid.json'))
  update_invalid_request_params = JSON.parse(File.read('public/json_examples/update_goal_invalid.json'))

  let(:test_user) { create :user }
  let(:test_goal) { create :goal, user: test_user }

  before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(test_user) }
  before { allow_any_instance_of(GoalsController).to receive(:goal).and_return(test_goal) }

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      get goals_path
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get goal_path(id: test_goal.to_param)
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'with valid params renders a JSON response with the new goal' do
      local_params = create_valid_request_params
      post goals_path, params: local_params
      expect(response).to have_http_status(:created)
      expect(response.content_type).to eq('application/vnd.api+json')
    end

    it 'with invalid params renders a JSON response with errors for the new goal' do
      local_params = create_invalid_request_params
      post goals_path, params: local_params
      expect(response).to have_http_status(:conflict)
      expect(response.content_type).to eq('application/vnd.api+json')
    end
  end

  describe 'PATCH #update' do
    it 'renders a JSON response with the goal' do
      local_params = update_valid_request_params
      patch goal_path(id: test_goal.to_param), params: local_params
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/vnd.api+json')
    end

    it 'renders a JSON response with errors for the goal' do
      local_params = update_invalid_request_params
      patch goal_path(id: test_goal.to_param), params: local_params
      expect(response).to have_http_status(:conflict)
      expect(response.content_type).to eq('application/vnd.api+json')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested goal' do
      delete goal_path(id: test_goal.to_param)
    end
  end
end
