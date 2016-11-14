class AddUnaccentExtension < ActiveRecord::Migration[5.0]
  def up
    execute "CREATE EXTENSION IF NOT EXISTS unaccent"
  end

  def down
    # Do nothing
  end
end
