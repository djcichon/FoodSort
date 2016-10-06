class GroceryTripsController < ApplicationController
  def new
		@grocery_trip = GroceryTrip.new
		@recipes = current_user.recipes
  end

  def edit
  end
end
