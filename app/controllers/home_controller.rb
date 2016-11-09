class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if current_user
      @recipes = current_user.recipes.order(:name)
      @grocery_trips = current_user.grocery_trips.order(updated_at: :desc)
    end
  end
end
