class Dish < ApplicationRecord
  belongs_to :grocery_trip
  belongs_to :recipe
end
