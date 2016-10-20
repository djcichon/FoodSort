require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "order cannot be negative" do
    product = Product.new(order: nil)
    assert product.valid?, "Expected product to be valid"

    product.order = -1
    assert_not product.valid?, "Expected product to be invalid"

    product.order = 1
    assert product.valid?, "Expected product to be valid"
  end
end
