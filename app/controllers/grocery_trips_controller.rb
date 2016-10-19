class GroceryTripsController < ApplicationController
  def new
    @grocery_trip = GroceryTrip.new
    @recipes = current_user.recipes
  end

  # Expects params[:recipe_id], returns a list of name/order pairs for it's ingredients.
  def get_ingredients
    recipe_id = params[:recipe_id].to_i
    recipe = Recipe.find_by(id: recipe_id)

    if recipe
      render json: recipe.products.map { |product| { name: product.name, order: product.order } }
    else
      # If the recipe is not found, gracefully return no ingredients
      render json: []
    end
  end
end
