require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:doug)

    @recipe = recipes(:hotdogs)

    @hotdogs = products(:hotdogs)
    @hotdog_buns = products(:hotdog_buns)
    @ketchup = products(:ketchup)
    @mustard = products(:mustard)
  end

  test "new should redirect to login when not signed in" do
    get products_url
    assert_redirected_to new_user_session_url
  end

  test "should get index" do
    sign_in @user

    # Items appear in unordered_products when order is nil
    get products_url
    assert_response :success

    assert_select "#unordered_products", 1
    assert_select "#unordered_products li", Product.count

    #TODO: I need a helper for getting all products which belong to a user
    Product.all.each do |product|
      assert_select "#unordered_products li", product.name
    end

    @recipe.products.each_with_index do |product, i|
      product.order = i
      product.save
    end

    # Items appear in ordered_products when order is not nil
    get products_url
    assert_response :success

    assert_select "#ordered_products", 1
    assert_select "#ordered_products li", 4
    assert_select "#ordered_products li", "Hot dogs"
    assert_select "#ordered_products li", "Hot dog buns"
    assert_select "#ordered_products li", "Ketchup"
    assert_select "#ordered_products li", "Mustard"
  end

  test "update product ordering" do
    sign_in @user

    params = { 
      products: { 
        "0": { id: @hotdogs.id, order: 0 },
        "1": { id: @hotdog_buns.id, order: 1 },
        "2": { id: @ketchup.id, order: 3 },
        "3": { id: @mustard.id, order: 2 },
      }
    }

    post products_url, params: params

    assert_nil flash[:danger]
    assert_not_nil flash[:success]

    assert_equal 0, @hotdogs.reload.order
    assert_equal 1, @hotdog_buns.reload.order
    assert_equal 3, @ketchup.reload.order
    assert_equal 2, @mustard.reload.order
  end

  test "error while updating product ordering" do
    sign_in @user

    # Use an invalid negative number for the order
    params = { 
      products: { 
        "0": { id: @hotdogs.id, order: 0 },
        "1": { id: @hotdog_buns.id, order: 1 },
        "2": { id: @ketchup.id, order: -1 },
        "3": { id: @mustard.id, order: 2 },
      }
    }

    post products_url, params: params

    assert_not_nil flash[:danger]
    assert_nil flash[:success]

    # None of the products should be updated
    assert_nil @hotdogs.reload.order
    assert_nil @hotdog_buns.reload.order
    assert_nil @ketchup.reload.order
    assert_nil @mustard.reload.order
  end
end
