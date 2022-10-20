Rails.application.routes.draw do
  resources :book_genres
  resources :genres
  resources :goodreads_list_books
  resources :goodreads_lists
  resources :books
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
