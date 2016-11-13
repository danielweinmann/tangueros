class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.integer :from_user_id, null: false, index: true
      t.integer :to_user_id, null: false, index: true
      t.references :match, null: false, index: true, foreign_key: true
      t.text :content, null: false
      t.boolean :read, null: false, default: false

      t.timestamps
    end
    add_foreign_key :messages, :users, column: :from_user_id
    add_foreign_key :messages, :users, column: :to_user_id
  end
end
