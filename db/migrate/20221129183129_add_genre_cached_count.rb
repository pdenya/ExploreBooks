class AddGenreCachedCount < ActiveRecord::Migration[6.1]
  def change
    add_column :genres, :cached_count, :integer
    add_index :genres, :cached_count, unique: false
  end
end
