class CreateRecipes < ActiveRecord::Migration[5.0]
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :category
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :recipes, [:user_id, :name], unique: true
  end
end
