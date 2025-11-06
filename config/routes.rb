Rails.application.routes.draw do
  root 'sessions#home'              # homepage route

  resources :pins                    # pins CRUD routes

  resources :users, only: [:new, :create, :edit, :update, :show, :destroy]

  # Sessions routes
  get '/login', to: 'sessions#new'
  resources :users, only: [:new, :create, :edit, :update, :show, :destroy]
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
