class CreateGoodreadsListBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :goodreads_list_books do |t|
      t.integer :rank
      t.references :book, null: false, foreign_key: true
      t.references :goodreads_list, null: false, foreign_key: true
      t.integer :score
      t.integer :voted

      t.timestamps
    end
  end
end
