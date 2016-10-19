class Product < ApplicationRecord

	has_many :recipe_products
	has_many :recipes, through: :recipe_products

	validates :order, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
