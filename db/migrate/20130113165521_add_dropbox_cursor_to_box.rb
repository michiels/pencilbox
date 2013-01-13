class AddDropboxCursorToBox < ActiveRecord::Migration
  def change
    add_column :boxes, :dropbox_cursor, :string
  end
end
