class AddGoodreadsListImportedAt < ActiveRecord::Migration[6.1]
  def change
    add_column :goodreads_lists, :imported_at, :datetime
    add_index :goodreads_lists, :goodreads_id, unique: true
  end
end
