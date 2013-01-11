class CreateBoxes < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.string :uid
      t.string :display_name
      t.string :dropbox_access_key
      t.string :dropbox_access_secret

      t.timestamps
    end
  end
end
