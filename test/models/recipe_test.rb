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
end
