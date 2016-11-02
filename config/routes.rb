Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks", 
    registrations: "users/registrations" 
  }
  resources :users, only: [:show] do
    collection do
      get :profile_image
      put :update_profile_image
      get :location
      put :update_location
    end
  end
  resources :loves, only: [:index, :create]
  resources :dismissals, only: [:create]
  resources :matches, only: [:index]
  root "users#index"
end
