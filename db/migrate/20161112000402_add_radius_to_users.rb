class AddRadiusToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :radius, :integer, null: false, default: 41000
  end
end
