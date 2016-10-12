require 'test_helper'

class GroceryTripsControllerTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:doug)
	end

  test "should get new" do
    get new_grocery_trip_url
    assert_response :success
  end

  test "should get edit" do
		trip = @user.grocery_trips.create

    get edit_grocery_trip_url(trip)
    assert_response :success
  end

end
