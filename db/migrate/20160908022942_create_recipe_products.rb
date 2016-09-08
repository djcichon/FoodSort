class CreateRecipeProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :recipe_products do |t|
      t.references :recipe, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
