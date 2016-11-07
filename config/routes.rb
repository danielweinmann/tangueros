Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks", 
    registrations: "users/registrations" 
  }
  require 'sidekiq/web'
  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  resources :users, only: [:show] do
    collection do
      get :roles
      put :update_roles
      get :profile_image
      put :update_profile_image
      get :location
      put :update_location
    end
  end
  resources :loves, only: [:index, :create]
  resources :dismissals, only: [:create]
  resources :matches, only: [:index]
  resources :notifications, only: [:index]
  post "/" => "facebook_canvas#index"
  root "users#index"
end
