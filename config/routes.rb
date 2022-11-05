Rails.application.routes.draw do

  get 'home/home'
  root  'home#home'

  resources :book_genres
  resources :genres
  resources :goodreads_list_books
  resources :goodreads_lists
  resources :books do
    collection do
      get 'explore'
    end
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
