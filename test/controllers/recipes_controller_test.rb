require 'test_helper'

class RecipesControllerTest < ActionController::TestCase
	include Devise::Test::ControllerHelpers

	def setup
		@user = users(:doug)
		@request.env["devise.mapping"] = Devise.mappings[:admin]

		sign_in @user
	end

  test "should get new" do
    get new_recipe_path
    assert_response :success
  end

  test "should get edit" do
		recipe = @user.recipes.create(name: "Food!")

    get edit_recipe_path(recipe)
    assert_response :success
  end

end
