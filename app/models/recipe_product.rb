class RecipeProduct < ApplicationRecord
	attr_accessor :name
  belongs_to :recipe, :inverse_of => :recipe_products
  belongs_to :product

	def name
		product.name unless product == nil
	end

	# Sets the product which corresponds to this name
	def name=(val)
		self.product = Product.find_or_initialize_by(name: val)
	end
end
