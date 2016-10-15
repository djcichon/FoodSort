class Recipe < ApplicationRecord
  belongs_to :user

	has_many :dishes
	has_many :recipe_products, :inverse_of => :recipe, :dependent => :destroy

	has_many :grocery_trips, through: :dishes
	has_many :products, through: :recipe_products

	accepts_nested_attributes_for :recipe_products
	#TODO: May not want this, could lead to product names changing accidentally.  Not sure yet.
	accepts_nested_attributes_for :products
	validates_uniqueness_of :name, :scope => :user_id

	before_save :combine_duplicate_products

	private
		def combine_duplicate_products
			# Maps product name to a unique product
			product_map = Hash.new

			recipe_products.each do |rp|

				# If the product name has been seen already, use the first product that was seen
				if product_map.include?(rp.name)
					rp.product = product_map[rp.name]

				# If the product name has not been seen yet, remember the unique product to use
				else
					product_map[rp.name] = rp.product
				end
			end
		end
end
