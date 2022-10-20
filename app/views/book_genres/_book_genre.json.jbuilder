json.extract! book_genre, :id, :book_id, :genre_id, :created_at, :updated_at
json.url book_genre_url(book_genre, format: :json)
