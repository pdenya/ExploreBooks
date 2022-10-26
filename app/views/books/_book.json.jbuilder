json.extract! book, :id, :goodreads_id, :title, :authors, :average_rating, :isbn, :isbn13, :language_code, :num_pages, :ratings_count, :text_reviews_count, :publication_date, :publisher, :genre_names, :description, :created_at, :updated_at
json.url book_url(book, format: :json)
