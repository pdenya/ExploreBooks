class AddIsbnsToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :isbn10s, :string, array: true, default: []
    add_column :books, :isbn13s, :string, array: true, default: []
    add_column :books, :publishers, :string, array: true, default: []
    add_column :books, :ol_sources, :string, array: true, default: []
  end
end
