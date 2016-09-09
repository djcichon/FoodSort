class Recipe < ApplicationRecord
  belongs_to :user
	has_many :grocery_trips, through: :dishes
	has_many :products, through: :recipe_products

	validates_uniqueness_of :name, :scope => :user_id
end
