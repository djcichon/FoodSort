class ProductsController < ApplicationController
  def index
		# Find all products associated with this user
		products = Product.order(:order).joins( :recipe_products => :recipe).where(:recipes => { :user_id => current_user } )

		@ordered_products = products.find_all { |product| product.order != nil }.uniq
		@unordered_products = products.find_all { |product| product.order == nil }.uniq
  end

	def update
		puts "All params: " + params.inspect

		params[:products].each do |key, product_params|
			puts "Product params: " + product_params.inspect
			id = product_params[:id].to_i
			product = Product.find(id)
			product.order = product_params[:order].to_i

			puts product.inspect
			
			if !product.save
				# TODO: Handle error
			end
		end

		# TODO: This redirect doesn't seem to be working, but orders are being saved
		# TODO: It just stays on the same page w/ a disabled save button
		redirect_to products_path
	end
end
