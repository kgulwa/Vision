Rails.application.routes.draw do
  # Homepage
  root 'sessions#home'

  # Pins CRUD
  resources :pins

  # Users routes
  resources :users, only: [:new, :create, :edit, :update, :show, :destroy]

  # Sessions routes
  get '/login', to: 'sessions#new', as: :login
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: :logout
  get '/search', to: 'pins#search', as: 'search'

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
