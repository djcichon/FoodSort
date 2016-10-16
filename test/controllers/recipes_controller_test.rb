require 'test_helper'

class RecipesControllerTest < ActionController::TestCase
	include Devise::Test::ControllerHelpers

	def setup
		@user = users(:doug)
		sign_in @user
	end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
		recipe = @user.recipes.create(name: "Food!")

    get :edit, params: { id: recipe.id }
    assert_response :success
  end

end
