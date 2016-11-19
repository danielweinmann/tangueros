class ChangeMatchIdNullOnMessages < ActiveRecord::Migration[5.0]
  def change
    change_column_null(:messages, :match_id, true)
  end
end
