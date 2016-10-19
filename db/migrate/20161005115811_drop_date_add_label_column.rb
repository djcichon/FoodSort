class DropDateAddLabelColumn < ActiveRecord::Migration[5.0]
  def change
    remove_column :grocery_trips, :date, :date
    add_column :grocery_trips, :label, :string
  end
end
