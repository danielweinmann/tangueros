class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.references :user, foreign_key: true
      t.integer :matched_user_id, index: true

      t.timestamps
    end
    add_foreign_key :matches, :users, column: :matched_user_id
    add_index :matches, [:user_id, :matched_user_id], unique: true
  end
end
