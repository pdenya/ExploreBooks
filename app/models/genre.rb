class Genre < ApplicationRecord

	has_many :book_genres, dependent: :delete_all
	has_many :books, :through => :book_genres

	def self.books_per
		Genre.joins(:books)
	        .select('genres.*, COUNT(books.id) as book_count')
	        .group('genres.id')
	        .order('book_count DESC')
	end

end
