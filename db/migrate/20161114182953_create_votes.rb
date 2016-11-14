class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.boolean :up, index: true, null: false
      t.belongs_to :restaurant, index: true
      t.timestamps
    end
  end
end
