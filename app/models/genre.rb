class Genre < ApplicationRecord

	has_many :book_genres, dependent: :delete_all
	has_many :books, :through => :book_genres

	def self.books_per
		Genre.joins(:books)
	        .select('genres.*, COUNT(books.id) as book_count')
	        .group('genres.id')
	        .order('book_count DESC')
	end

	def self.set_cached_counts
		ActiveRecord::Base.connection.execute(
			"UPDATE genres SET cached_count=(SELECT COUNT(DISTINCT(book_id)) FROM book_genres WHERE genre_id = genres.id)"
		)
	end
end
