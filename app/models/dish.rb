class Dish < ApplicationRecord
  belongs_to :grocery_trip
  belongs_to :recipe

  def name()
    recipe.name unless recipe == nil
  end
end
