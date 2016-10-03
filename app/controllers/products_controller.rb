class ProductsController < ApplicationController
  def index
		# Find all products associated with this user
		products = Product.joins( :recipe_products => :recipe).where(:recipes => { :user_id => current_user } )

		@ordered_products = products.find_all { |product| product.order != nil }.uniq
		@unordered_products = products.find_all { |product| product.order == nil }.uniq
  end
end
