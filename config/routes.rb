Rails.application.routes.draw do

  devise_for :users
  root 'home#index'

	post 'products' => 'products#update'
	resources :products, only: [:index]
	resources :recipes, only: [:new, :create, :edit, :update]
end
