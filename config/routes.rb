Rails.application.routes.draw do
  root 'sessions#home'

  resources :pins, param: :uid do
    resources :comments, param: :uid
    resource :like, only: [:create, :destroy]
    resource :repost, only: [:create, :destroy]
    resources :saved_pins, only: [:create, :destroy], param: :uid
  end

  resources :users, param: :uid do
    resource :follow, only: [:create, :destroy]
    collection do
      get :check_email
      get :check_username
      get :check_username_exists
      post :check_password
    end
  end

  resources :collections, only: [:show, :create], param: :uid

  get '/login', to: 'sessions#new', as: :login
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: :logout

  get '/search', to: 'pins#search', as: :search

  get "up" => "rails/health#show", as: :rails_health_check
end
