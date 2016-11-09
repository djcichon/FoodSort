class GroceryTripsController < ApplicationController
  def new
    @grocery_trip = GroceryTrip.new
    @grocery_trip.populate_dishes(current_user.recipes)
  end

  def create
    grocery_trip = current_user.grocery_trips.create

    # Add a dish to the grocery trip for every non-zero count
    grocery_trip_params[:dishes_attributes].each do |index, dish_params|
      count = dish_params[:count].to_i
      recipe_id = dish_params[:recipe_id].to_i

      grocery_trip.dishes.new(recipe_id: recipe_id, count: count) unless count <= 0
    end

    grocery_trip.label = grocery_trip_params[:label]

    if grocery_trip.save
      flash[:success] = "Grocery Trip successfully created"
      redirect_to root_url
    else
      puts grocery_trip.dishes.inspect
      puts grocery_trip.errors.messages
      #TODO: Handle this error case better
      flash[:danger] = "An error has occurred, and it is not yet handled well"
      redirect_to new_grocery_trip_url
    end
  end

  def edit
    @grocery_trip = GroceryTrip.find(params[:id])
    @grocery_trip.populate_dishes(current_user.recipes)

    #TODO: Generate the list of ingredients here to be rendered in the view
  end

  def update
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

  private
    def grocery_trip_params
      params.require(:grocery_trip).permit(:label, dishes_attributes: [:recipe_id, :count])
    end
end
