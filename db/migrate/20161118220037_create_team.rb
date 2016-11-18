class CreateTeam < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :slack_id
      t.timestamps
    end

    add_column :votes, :team_id, :integer
    add_index :votes, :team_id
  end
end
