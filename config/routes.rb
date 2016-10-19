Rails.application.routes.draw do

  devise_for :users
  root 'home#index'

  post 'products' => 'products#update'
  get 'grocery_trips/get_ingredients' => 'grocery_trips#get_ingredients'
  resources :products, only: [:index]
  resources :recipes, only: [:new, :create, :edit, :update]
  resources :grocery_trips, only: [:new, :create, :edit, :update]
end
