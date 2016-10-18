require 'test_helper'

class RecipesControllerTest < ActionDispatch::IntegrationTest
	include Devise::Test::IntegrationHelpers

	def setup
		@user = users(:doug)
		sign_in @user
	end

  test "should get new" do
    get new_recipe_url
    assert_response :success

		assert_select "h1", "Add Recipe"
		assert_select "h2", "Ingredients (0)"
  end

	test "create new recipe" do
		params = { 
			recipe: { 
				name: "Chocolate covered kale", 
				category: "Vegan",
				recipe_products_attributes: [ { name: "Chocolate" }, { name: "Kale" } ]
			} 
		}

		assert_difference "Recipe.count", 1 do
			post recipes_url, params: params
		end
		assert_redirected_to root_url

		recipe = Recipe.find_by(name: "Chocolate covered kale")

		assert_not_nil recipe
		assert_equal "Chocolate covered kale", recipe.name
		assert_equal "Vegan", recipe.category

		assert_equal 2, recipe.products.size
		assert_not_nil recipe.products.find_by(name: "Chocolate")
		assert_not_nil recipe.products.find_by(name: "Kale")
	end

	test "error while creating recipe" do
		# Create a recipe which with the same name
		recipe = @user.recipes.create(name: "Chocolate covered kale")

		params = { 
			recipe: { 
				name: "Chocolate covered kale", 
				category: "Vegan",
				recipe_products_attributes: [ { name: "Chocolate" }, { name: "Kale" } ]
			} 
		}

		assert_no_difference "Recipe.count" do
			post recipes_url, params: params
		end

		# Create page is rendered, and still has original arguments in it
		assert_select "h1", "Add Recipe"
		assert_select "h2", "Ingredients (2)"
		assert_select "li", "Chocolate"
		assert_select "li", "Kale"

		assert_select "div#error_messages", 1
	end

  test "should get edit" do
		recipe = @user.recipes.create(name: "Food!")
		recipe.recipe_products.create(name: "Bacon")

    get edit_recipe_url(recipe)
    assert_response :success

		assert_select "h1", "Edit Recipe"
		assert_select "h2", "Ingredients (1)"
		assert_select "li", "Bacon"
  end

	test "update a recipe" do
		# Create a recipe to update
		recipe = @user.recipes.create(name: "Chocolate covered kale")

		params = { 
			recipe: { 
				id: recipe.id,
				name: "Kale covered chocolate", 
				category: "Delicious",
				recipe_products_attributes: [ { name: "Chocolate" }, { name: "Kale" } ]
			} 
		}

		assert_no_difference "Recipe.count" do
			patch recipe_url(recipe.id), params: params
		end
		assert_redirected_to root_url

		recipe = Recipe.find(recipe.id)

		assert_not_nil recipe
		assert_equal params[:recipe][:name], recipe.name
		assert_equal params[:recipe][:category], recipe.category

		assert_equal 2, recipe.products.size
		assert_not_nil recipe.products.find_by(name: "Chocolate")
		assert_not_nil recipe.products.find_by(name: "Kale")
	end

	test "error while updating recipe" do
		# Create a recipe to update
		recipe = @user.recipes.create(name: "Chocolate covered kale")

		# Create a recipe with a name we'll update to
		other_recipe = @user.recipes.create(name: "Kale covered chocolate")

		params = { 
			recipe: { 
				id: recipe.id,
				name: other_recipe.name, 
				category: "Delicious",
				recipe_products_attributes: [ { name: "Chocolate" }, { name: "Kale" } ]
			} 
		}

		assert_no_difference "Recipe.count" do
			patch recipe_url(recipe.id), params: params
		end

		# Edit page is rendered, and still has original arguments in it
		assert_select "h1", "Edit Recipe"
		assert_select "#recipe_name[value=?]", params[:recipe][:name]
		assert_select "#recipe_category[value=?]", params[:recipe][:category]
		assert_select "h2", "Ingredients (2)"
		assert_select "li", "Chocolate"
		assert_select "li", "Kale"
	end
end
