# Custom resource provider
module ApiResource
  def api_resource(resource_name, opts = {}, &block)
    #opts = opts.merge(except: [])
    resources(resource_name, opts, &block)
    post "#{resource_name}/:id" => "#{resource_name}#update"
    post "#{resource_name}/search" => "#{resource_name}#search", as: "#{resource_name}_search"
  end
end
# Make available in routes.draw
ActionDispatch::Routing::Mapper.include(ApiResource)


Rails.application.routes.draw do

  get 'home/home'
  root  'books#index'

  resources :book_genres
  resources :genres do
    collection do
      post 'search'
    end
  end
  resources :goodreads_list_books
  resources :goodreads_lists
  resources :books do
    collection do
      get 'explore'
      post 'tags'
    end
  end

  namespace :api do
    api_resource :genres
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
