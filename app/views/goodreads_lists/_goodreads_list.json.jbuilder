json.extract! goodreads_list, :id, :goodreads_id, :name, :description, :created_at, :updated_at
json.url goodreads_list_url(goodreads_list, format: :json)
