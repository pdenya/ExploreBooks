class Book < ApplicationRecord

	has_many :book_genres
	has_many :genres, :through => :book_genres

	def goodreads_link
		"https://www.goodreads.com/book/show/#{self.goodreads_id}"
	end

	def import(driver: nil)
		Rails.logger.info "Importing #{self.goodreads_id}"
		driver ||= Selenium::WebDriver.for(:chrome, options: Selenium::WebDriver::Chrome::Options.new(args: ['headless']))
		driver.get(self.goodreads_link)

		begin
			title_read = driver.find_element(css: 'h1#bookTitle').text.strip rescue false

			if title_read
				Rails.logger.info "Import type OLD"
				# older goodreads layout
				self.title ||= title_read
				self.authors ||= driver.find_elements(css: 'div#bookAuthors span[itemprop="author"]').map(&:text).uniq.join(', ')
				self.average_rating ||= driver.find_element(css: 'span[itemprop="ratingValue"]').text.strip.to_d
				self.isbn13 ||= driver.find_element(css: 'meta[property="books:isbn"]')['content']
				self.isbn ||= driver.find_element(xpath:'//*[@id="bookDataBox"]/div[2]/div[2]').text.to_i.to_s
				self.language_code ||= driver.find_element(css: 'div[itemprop="inLanguage"]').attribute('innerHTML')
				self.num_pages ||= driver.find_element(css: 'span[itemprop="numberOfPages"]').text.to_i
				self.ratings_count ||= driver.find_element(css: 'meta[itemprop="ratingCount"]')['content'].to_i
				self.text_reviews_count ||= driver.find_element(css: 'meta[itemprop="reviewCount"]')['content'].to_i
				self.publication_date ||= Date.parse(driver.find_element(xpath: "//div[@class='row' and contains(text(),'Published')]").text)
				self.publisher ||= driver.find_element(xpath: "//div[@class='row' and contains(text(),'Published')]").text.strip.split('by').last.strip
				self.genre_names ||= driver.find_elements(css: 'a.bookPageGenreLink').map(&:text).uniq.join('|')
				self.description ||= driver.find_element(css: '#description').text.strip
			else
				#newer goodreads layout
				data = JSON.parse(driver.find_element(xpath: '//script[@type="application/ld+json"]').attribute('innerHTML'))
				Rails.logger.info "Import type NEW2 - #{data}"

				self.title ||= data["name"]
				self.authors ||= data["author"].map{ |a| a["name"] }.uniq.join(', ')
				self.average_rating ||= data['aggregateRating']['ratingValue']
				self.isbn13 ||= data['isbn']
				self.language_code ||= data['inLanguage']
				self.num_pages ||= data['numberOfPages']
				self.ratings_count ||= data['aggregateRating']['ratingCount']
				self.text_reviews_count ||= data['aggregateRating']['reviewCount']
				self.publication_date ||= Date.parse(driver.find_element(xpath: "//div[@class='BookDetails']//p[contains(text(),'published')]").text)
				# can't find publisher rn
				#self.publisher ||= driver.find_element(xpath: "//div[@class='row' and contains(text(),'Published')]").text.strip.split('by').last.strip
				self.genre_names ||= driver.find_elements(css: 'span.BookPageMetadataSection__genreButton').map(&:text).uniq.join('|')
				self.description ||= driver.find_element(css: '.BookPageMetadataSection__description').text
			end
		rescue => e
			Rails.logger.error(e.message)

			if driver.page_source.length > 300
				Rails.logger.error("HTML written to error_on_book#{self.id}.html")
				file = File.new("error_on_book#{self.id}.html", "w")
				file.puts(driver.page_source)
				file.close
			else
				Rails.logger.error("Page length: #{driver.page_source.length}, discarding")
			end

			#Rails.logger.error(e.backtrace)
		end

		self.save

		self.create_genres if self.genre_names

		driver
	end

	def create_genres
		return unless self.genre_names.present?
		self.genre_names.split('|').each do |genre_name|
			genre = Genre.where(name:genre_name).first
			genre ||= Genre.create(name: genre_name)

			BookGenre.create(book: self, genre: genre)
		end
	end

	def self.import(return_driver: false)
		imported = 0
		errors = 0
		t1 = Time.now
		@driver = nil

		Book.where(title:nil).order('id DESC').limit(300).each do |book|
			Rails.logger.info "#{imported} imported, #{errors} errors. Running for #{Time.now - t1} seconds."

			driver = book.import(driver: @driver)
			@driver ||= driver

			sleep 15

			if book.title.present?
				imported += 1
			else
				errors += 1
				sleep 120
			end
		end

		Rails.logger.info "Complete: #{imported} imported, #{errors} errors. Ran for #{(Time.now - t1)/60} minutes."

		return_driver && @driver ? @driver : @driver.quit
	end
end
