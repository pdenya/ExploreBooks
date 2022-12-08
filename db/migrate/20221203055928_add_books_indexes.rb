class AddBooksIndexes < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :quality, :boolean, default: false
  end
end
