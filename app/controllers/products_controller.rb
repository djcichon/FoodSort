class ProductsController < ApplicationController
  def index
		# Find all products associated with this user
		products = Product.order(:order).joins( :recipe_products => :recipe).where(:recipes => { :user_id => current_user } )

		@ordered_products = products.find_all { |product| product.order != nil }.uniq
		@unordered_products = products.find_all { |product| product.order == nil }.uniq
  end

	def update
		Product.transaction do
			params[:products].each do |key, product_params|
				id = product_params[:id].to_i
				order = product_params[:order].to_i

				product = Product.find(id)
				product.order = order
				
				if !product.save
					flash[:danger] = "An error occurred while saving your product ordering, please try again."
					raise ActiveRecord::Rollback
				end
			end
		end

		redirect_to products_path
	end
end
