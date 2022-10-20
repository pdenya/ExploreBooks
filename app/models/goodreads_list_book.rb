class GoodreadsListBook < ApplicationRecord
  belongs_to :book
  belongs_to :goodreads_list
end
