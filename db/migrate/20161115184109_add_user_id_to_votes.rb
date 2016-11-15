class AddUserIdToVotes < ActiveRecord::Migration[5.0]
  def change
    add_column :votes, :user_id, :string, index: true
  end
end
