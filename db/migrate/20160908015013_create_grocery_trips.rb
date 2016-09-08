class CreateGroceryTrips < ActiveRecord::Migration[5.0]
  def change
    create_table :grocery_trips do |t|
      t.date :date
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
