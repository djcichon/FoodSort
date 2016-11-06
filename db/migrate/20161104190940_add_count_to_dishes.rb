class AddCountToDishes < ActiveRecord::Migration[5.0]
  def change
    add_column :dishes, :count, :integer
  end
end
