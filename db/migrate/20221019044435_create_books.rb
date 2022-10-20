class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.integer :goodreads_id
      t.string :title
      t.string :authors
      t.decimal :average_rating
      t.string :isbn
      t.string :isbn13
      t.string :language_code
      t.integer :num_pages
      t.integer :ratings_count
      t.integer :text_reviews_count
      t.date :publication_date
      t.string :publisher
      t.string :genres
      t.text :description

      t.timestamps
    end
  end
end
