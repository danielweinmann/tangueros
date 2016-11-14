class AddPgTrgmExtension < ActiveRecord::Migration[5.0]
  def up
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm"
  end

  def down
    # Do nothing
  end
end
