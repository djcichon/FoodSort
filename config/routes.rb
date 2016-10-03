Rails.application.routes.draw do

  devise_for :users
  root 'home#index'

  get 'products' => 'product#index'

	resources :recipes, only: [:new, :create, :edit, :update]
end
