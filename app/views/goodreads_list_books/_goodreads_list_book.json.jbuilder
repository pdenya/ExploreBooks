json.extract! goodreads_list_book, :id, :rank, :book_id, :goodreads_list_id, :score, :voted, :created_at, :updated_at
json.url goodreads_list_book_url(goodreads_list_book, format: :json)
