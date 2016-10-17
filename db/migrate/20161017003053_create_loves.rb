class CreateLoves < ActiveRecord::Migration[5.0]
  def change
    create_table :loves do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :loved_user_id, index: true

      t.timestamps
    end
    add_foreign_key :loves, :users, column: :loved_user_id
    add_index :loves, [:user_id, :loved_user_id], unique: true
  end
end
