class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true, null: false
      t.integer :triggering_user_id, index: true
      t.references :love, foreign_key: true
      t.references :match, foreign_key: true
      t.text :content, null: false
      t.text :email_subject, null: false
      t.text :email_content
      t.text :push_subject
      t.text :push_content
      t.text :facebook_content
      t.boolean :read, null: false, default: false

      t.timestamps
    end
    add_foreign_key :notifications, :users, column: :triggering_user_id
    add_index :notifications, :read
    add_index :notifications, [:user_id, :read]
  end
end
