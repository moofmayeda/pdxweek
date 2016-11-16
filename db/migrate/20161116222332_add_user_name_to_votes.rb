class AddUserNameToVotes < ActiveRecord::Migration[5.0]
  def change
    add_column :votes, :user_name, :string
  end
end
