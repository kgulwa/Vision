Rails.application.routes.draw do
  # Homepage
  root 'sessions#home'

  # Pins with nested routes
  resources :pins do
    resources :comments   # added full CRUD so Reply + Edit work
    resource :like, only: [:create, :destroy]
    resource :repost, only: [:create, :destroy]
  end

  # Users with nested routes
  resources :users do
    resource :follow, only: [:create, :destroy]
    collection do
      get :check_email
      get :check_username
      get :check_username_exists
      post :check_password
    end
  end

  # Sessions
  get '/login', to: 'sessions#new', as: :login
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: :logout
  
  # Search
  get '/search', to: 'pins#search', as: 'search'

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
