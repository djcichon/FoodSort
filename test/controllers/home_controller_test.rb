require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "home when logged in" do
    @user = users(:doug)
    sign_in @user

    get root_url
    assert_response :success
    assert_select 'a', 'New Recipe'
  end

  test "home when not logged in" do
    get root_url
    assert_response :success
    assert_select 'a', 'Create account'
  end
end
