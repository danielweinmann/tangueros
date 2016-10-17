Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks", 
    registrations: "users/registrations" 
  }
  resources :users, only: [] do
    collection do
      get :profile_image
      put :update_profile_image
      get :location
      put :update_location
    end
  end
  resources :loves, only: [:create]
  resources :dismissals, only: [:create]
  root "users#index"
end
