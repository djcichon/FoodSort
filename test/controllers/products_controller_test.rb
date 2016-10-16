require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
	include Devise::Test::ControllerHelpers

	def setup
		@user = users(:doug)
		sign_in @user
	end

  test "should get index" do
    get :index
    assert_response :success
  end

end
