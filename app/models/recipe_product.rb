class RecipeProduct < ApplicationRecord
  belongs_to :recipe
  belongs_to :product

	def name
		product.name
	end
end
