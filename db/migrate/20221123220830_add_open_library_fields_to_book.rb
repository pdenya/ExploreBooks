class AddOpenLibraryFieldsToBook < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :subtitle, :string
    add_column :books, :openlibrary_id, :string
    add_column :books, :openlibrary_cover_ids, :string

    add_index :books, :openlibrary_id, unique: true
  end
end
