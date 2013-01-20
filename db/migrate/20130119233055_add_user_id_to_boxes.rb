class AddUserIdToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :user_id, :integer
    add_index :boxes, :user_id
  end
end
