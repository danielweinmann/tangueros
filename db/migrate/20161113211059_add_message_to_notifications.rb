class AddMessageToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_reference :notifications, :message, foreign_key: true
  end
end
