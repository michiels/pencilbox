class AddDirnameToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :dirname, :string
  end
end
