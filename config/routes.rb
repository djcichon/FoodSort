Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

	resources :recipes, only: [:new, :create, :edit, :update]
end
