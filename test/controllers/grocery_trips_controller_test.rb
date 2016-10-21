require 'test_helper'

class GroceryTripsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:doug)
  end

  test "new should redirect to login when not signed in" do
    get new_grocery_trip_url
    assert_redirected_to new_user_session_url
  end

  test "get_ingredients should redirect to login when not signed in" do
    get grocery_trips_get_ingredients_url
    assert_redirected_to new_user_session_url
  end

  test "should get new" do
    sign_in @user

    get new_grocery_trip_url
    assert_response :success

    assert_select "h1", "Create Grocery Trip"

    # Should list all recipes
    @user.recipes.each do |recipe|
      assert_select "#recipe_list .card .recipe-name", recipe.name
    end
  end

  test "get ingredients for existing recipe" do
    sign_in @user

    recipe      = recipes(:hotdogs)
    hotdogs     = products(:hotdogs)
    hotdog_buns = products(:hotdog_buns)
    ketchup     = products(:ketchup)
    mustard     = products(:mustard)

    hotdogs.order     = 1
    hotdog_buns.order = 2
    ketchup.order     = 3
    mustard.order     = 4

    hotdogs.save
    hotdog_buns.save
    ketchup.save
    mustard.save

    get grocery_trips_get_ingredients_url, params: { recipe_id: recipe.id }

    json = JSON.parse(response.body)
    assert_equal 4, json.size

    json_hotdogs     = json.detect { |it| it["name"] == "Hot dogs" }
    json_hotdog_buns = json.detect { |it| it["name"] == "Hot dog buns" }
    json_ketchup     = json.detect { |it| it["name"] == "Ketchup" }
    json_mustard     = json.detect { |it| it["name"] == "Mustard" }

    assert_equal hotdogs.order, json_hotdogs["order"]
    assert_equal hotdog_buns.order, json_hotdog_buns["order"]
    assert_equal ketchup.order, json_ketchup["order"]
    assert_equal mustard.order, json_mustard["order"]
  end

  test "get ingredients for non-existing recipe" do
    sign_in @user
    get grocery_trips_get_ingredients_url, params: { recipe_id: -1 }

    json = JSON.parse(response.body)

    assert_equal 0, json.size
  end
end
