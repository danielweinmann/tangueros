class NewRadiusDefaultOnUsers < ActiveRecord::Migration[5.0]
  def up
    change_column_default :users, :radius, 240
    execute("UPDATE users SET radius = 240 WHERE radius = 22000")
  end

  def down
    change_column_default :users, :radius, 22000
  end
end
