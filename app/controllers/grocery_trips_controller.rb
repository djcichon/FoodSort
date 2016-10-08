class GroceryTripsController < ApplicationController
  def new
		@grocery_trip = GroceryTrip.new
		@recipes = current_user.recipes
  end

  def edit
  end

	# Expects params[:recipe_id], returns a list of name/order pairs for it's ingredients.
	def get_ingredients
		recipe = Recipe.find(params[:recipe_id].to_i)

		#TODO: Handle recipe not found
		render json: recipe.products.map { |product| { name: product.name, order: product.order } }
	end
end
