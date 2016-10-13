Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks", 
    registrations: "users/registrations" 
  }
  resources :users, only: [] do
    collection do
      get :profile_image
      put :update_profile_image
    end
  end
  root "users#index"
end
