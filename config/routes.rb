Rails.application.routes.draw do
  get 'recipes/new'

  get 'recipes/create'

  get 'recipes/edit'

  get 'recipes/update'

  devise_for :users
  root 'home#index'

	resources :recipes, only: [:new, :create, :edit, :update]
end
