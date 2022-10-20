class Book < ApplicationRecord

	def goodreads_link
		"https://www.goodreads.com/book/show/#{self.goodreads_id}"
	end

	def import
		Rails.logger.info "Importing #{self.id}"
		response = HTTParty.get(self.goodreads_link)
		doc = Nokogiri::HTML(response.body)

		begin
			self.title ||= doc.css('h1#bookTitle')[0].text.strip
			self.authors ||= doc.css('div#bookAuthors span[itemprop="author"]').text.strip
			self.average_rating ||= doc.css('span[itemprop="ratingValue"]').first.text.strip.to_d
			self.isbn13 ||= doc.css('meta[property="books:isbn"]').first['content']
			self.isbn ||= doc.xpath('//*[@id="bookDataBox"]/div[2]/div[2]').text.to_i.to_s
			self.language_code ||= doc.css('div[itemprop="inLanguage"]').text
			self.num_pages ||= doc.css('span[itemprop="numberOfPages"]').text.to_i
			self.ratings_count ||= doc.css('meta[itemprop="ratingCount"]').first['content'].to_i
			self.text_reviews_count ||= doc.css('meta[itemprop="reviewCount"]').first['content'].to_i
			self.publication_date ||= Date.parse(doc.css('div.row:contains("Published")').first.text)
			self.publisher ||= doc.css('div.row:contains("Published")').first.text.strip.split("\n").last.strip
			self.genres ||= doc.css('a.bookPageGenreLink').map(&:text).join('|')
			self.description ||= doc.css('#description').first.text.strip
		rescue => e
			Rails.logger.error(e.message)
		end

		self.save

		doc
	end

	def create_genres
		return unless self.genres.present?
		self.genres.split('|').each do |genre_name|
			genre = Genre.where(name:genre_name).first
			genre ||= Genre.create(name: genre_name)

			BookGenre.create(book: self, genre: genre)
		end
	end

	def self.import
		imported = 0
		failed = 0
		total_failed = 0
		errors = []

		Book.where(title:nil).limit(300).each do |book|
			Rails.logger.info "#{imported} imported, #{total_failed} failed, #{failed} failed in a row"
			begin
				result = book.import
			rescue => e
				Rails.logger.error(e.message)
				result = false
			end

			if result
				imported += 1
				failed = 0
			else
				failed += 1
				total_failed += 1
			end
			sleep 10

			break if failed > 4
		end

		Rails.logger.info "Result: #{imported} imported, #{total_failed} failed, #{failed} failed in a row"
		[imported, total_failed, failed]
	end
end
