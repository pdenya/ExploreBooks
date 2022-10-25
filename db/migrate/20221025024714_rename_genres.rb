class RenameGenres < ActiveRecord::Migration[6.1]
  def change
    rename_column :books, :genres, :genre_names
  end
end
