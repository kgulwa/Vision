Rails.application.routes.draw do
  root 'sessions#home'

  resources :pins do
    resources :comments
    resource :like, only: [:create, :destroy]
    resource :repost, only: [:create, :destroy]
    resources :saved_pins, only: [:create, :destroy]
  end

  # USERS — back to standard :id (uuid) routing
  resources :users do
    resource :follow, only: [:create, :destroy]

    collection do
      get :check_email
      get :check_username
      get :check_username_exists
      post :check_password
    end

    member do
      get :tagged
    end
  end

  resources :collections, only: [:show, :create]

  get "/saved", to: "collections#saved", as: :saved

  # AUTH
  get '/login', to: 'sessions#new', as: :login
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: :logout

  # SEARCH
  get '/search', to: 'pins#search', as: :search
  get '/search/users', to: 'search#users', as: :user_search
  delete '/search/clear_history', to: 'search#clear_history', as: :clear_search_history

  # MENTIONS AUTOCOMPLETE
  get '/mentions', to: 'mentions#index'

  # NOTIFICATIONS
  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end

    collection do
      patch :mark_all_read
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
