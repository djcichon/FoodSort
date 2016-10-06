require 'test_helper'

class GroceryTripsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get grocery_trips_new_url
    assert_response :success
  end

  test "should get edit" do
    get grocery_trips_edit_url
    assert_response :success
  end

end
