class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.belongs_to :box
      t.string :path
      t.datetime :published_at
      t.text :body, :limit => 1.megabyte - 1

      t.timestamps
    end
  end
end
