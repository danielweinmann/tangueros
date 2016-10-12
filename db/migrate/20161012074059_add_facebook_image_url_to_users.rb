class AddFacebookImageUrlToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :facebook_image_url, :string
  end
end
