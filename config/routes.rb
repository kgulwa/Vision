Rails.application.routes.draw do
  root 'sessions#home'

  # PINS
  resources :pins do
    resources :comments
    resource :like, only: [:create, :destroy]
    resource :repost, only: [:create, :destroy]
    resources :saved_pins, only: [:create, :destroy]
  end

  # USERS + FOLLOW + INSIGHTS
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
      get :insights, to: "insights#show", as: :insights
    end
  end

  # VIDEO VIEW TRACKING
  resources :video_views, only: [:update]

  # COLLECTION ROUTES
  resources :collections, only: [:show, :create, :edit, :update, :destroy] do
    delete "remove_pin/:saved_pin_id", to: "collections#remove_pin", as: :remove_pin
  end
  get "/saved", to: "collections#saved", as: :saved

  # AUTH
  get '/login', to: 'sessions#new', as: :login
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: :logout

  # PASSWORD RESET
  get  "/forgot-password", to: "password_resets#new",    as: :forgot_password
  post "/forgot-password", to: "password_resets#create"
  get  "/reset-password",  to: "password_resets#edit",   as: :reset_password
  patch "/reset-password", to: "password_resets#update"

  # EMAIL VERIFICATION
  get "/verify-email", to: "email_verifications#update", as: :verify_email

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
