class Recipe < ApplicationRecord
  belongs_to :user

	has_many :dishes
	has_many :recipe_products, :inverse_of => :recipe

	has_many :grocery_trips, through: :dishes
	has_many :products, through: :recipe_products

	accepts_nested_attributes_for :recipe_products
	#TODO: May not want this, could lead to product names changing accidentally.  Not sure yet.
	accepts_nested_attributes_for :products
	validates_uniqueness_of :name, :scope => :user_id
end
