class GroceryTrip < ApplicationRecord
  belongs_to :user
  has_many :recipes, through: :dishes
end
