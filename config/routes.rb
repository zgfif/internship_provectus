Rails.application.routes.draw do
  resources :goals do
    resources :events do
      resources :tasks
    end
  end

  resources :events do
    resources :tasks
  end

  get 'auth/google_oauth2/callback', to: 'sessions#signin'
  get '/me', to: 'users#me'
  get '/sync', to: 'events#sync'
  get '/sync_log_history', to: 'events#sync_log_history'
  get '/update_work_time', to: 'users#update_work_time'
  post '/goals/:goal_id/events/global', to: 'events#create_global'
  put '/goals/:goal_id/events/:id/global', to: 'events#update_global'
  post '/events/global', to: 'events#create_global'
  put '/events/:id/global', to: 'events#update_global'
  post '/goals/global', to: 'goals#create_global'
  put '/goals/:id/global', to: 'goals#update_global'
  get '/my_data', to: 'users#my_data'
  get '/update_events_attributes', to: 'users#update_events_attributes'
  get '/get_old_events', to: 'events#get_old_events'
  patch '/goals/:id/update_relations', to: 'goals#update_relations'
  get '/update_sync_enabled', to: 'users#update_sync_enabled'
  post '/events/show_many', to: 'events#show_many'
  post '/goals/assigned', to: 'goals#create_assigned'
  put '/goals/:id/assigned', to: 'goals#update_assigned'
end
