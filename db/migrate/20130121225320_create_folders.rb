class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.string :path
      t.belongs_to :box

      t.timestamps
    end
  end
end
