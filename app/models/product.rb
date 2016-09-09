class Product < ApplicationRecord
	has_many :recipes, through: :recipe_products
end
