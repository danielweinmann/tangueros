class CreateDismissals < ActiveRecord::Migration[5.0]
  def change
    create_table :dismissals do |t|
      t.references :user, foreign_key: true
      t.integer :dismissed_user_id, index: true

      t.timestamps
    end
    add_foreign_key :dismissals, :users, column: :dismissed_user_id
    add_index :dismissals, [:user_id, :dismissed_user_id], unique: true
  end
end
