require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
	def setup
		@user = users(:doug)
	end

	test "user cannot create two recipes with the same name" do
		assert_difference 'Recipe.count', 1 do
			@user.recipes.create(name: "yummy")

			# Shouldn't be created since it already exists
			@user.recipes.create(name: "yummy")
		end
	end

	test "duplicate products by name should point to same product" do
		# Create a recipe with two of the same product
		recipe = @user.recipes.new(name: "yummy")
		recipe.recipe_products.new(name: "kale")
		recipe.recipe_products.new(name: "kale")

		assert recipe.valid?

		# Only one Product should be created when saving
		assert_difference 'Product.count', 1 do
			recipe.save
		end

    # After saving, both should point to the same product
		assert_equal 2, recipe.products.size
		assert_equal 2, recipe.recipe_products.size
		assert_equal recipe.products[0], recipe.products[1]
	end
end
