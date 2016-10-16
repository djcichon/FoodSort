require 'test_helper'

class GroceryTripsControllerTest < ActionController::TestCase
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
		trip = @user.grocery_trips.create

    get :edit, params: {id: trip.id}
    assert_response :success
  end

end
