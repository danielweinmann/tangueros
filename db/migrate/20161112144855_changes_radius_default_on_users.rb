class ChangesRadiusDefaultOnUsers < ActiveRecord::Migration[5.0]
  def up
    change_column_default :users, :radius, 22000
    execute("UPDATE users SET radius = 22000 WHERE radius > 22000")
  end

  def down
    change_column_default :users, :radius, 41000
  end
end
