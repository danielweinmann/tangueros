class AddFollowerLeaderColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :follower, :boolean
    add_column :users, :leader, :boolean
    add_index :users, :follower
    add_index :users, :leader
  end
end
