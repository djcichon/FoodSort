class CreateDishes < ActiveRecord::Migration[5.0]
  def change
    create_table :dishes do |t|
      t.references :grocery_trip, foreign_key: true
      t.references :recipe, foreign_key: true

      t.timestamps
    end
  end
end
