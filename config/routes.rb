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
      get :radius
      put :update_radius
      get :deactivate
      get :reactivate
      put :update_active
      get :invite
    end
  end
  resources :loves, only: [:index, :create, :destroy]
  resources :dismissals, only: [:create]
  resources :matches, only: [:index, :show]
  resources :notifications, only: [:index]
  resources :settings, only: [:index]
  resources :pages, only: [:index]
  resources :messages, only: [:create]
  resources :facebook_canvas, only: [] do
    collection do
      post :index
      post :invite
    end
    member do
      post :show
    end
  end
  root "users#index"
end
