class CreateDishes < ActiveRecord::Migration[5.0]
  def change
    create_table :dishes do |t|
      t.string :name
      t.string :category
      t.integer :year
      t.belongs_to :restaurant, index: true
      t.timestamps
    end
    add_index :dishes, [:category, :year]
    add_column :votes, :dish_id, :integer, index: true
    remove_column :votes, :restaurant_id, :integer, index: true
  end
end
