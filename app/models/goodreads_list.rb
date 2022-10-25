class GoodreadsList < ApplicationRecord

	has_many :goodreads_list_books
	has_many :books, :through => :goodreads_list_books

	def import
		last_id = Book.last.id
		t1 = Time.now

		40.times do |page|
			response = HTTParty.get("https://www.goodreads.com/list/show/#{self.goodreads_id}?page=#{page + 1}")
			doc = Nokogiri::HTML(response.body)

			self.name ||= doc.css('h1')[0].text.strip rescue nil
			self.description ||= doc.css('h1+div')[0].text.sub(/flag$/, '').strip rescue nil

			trs = doc.css('#all_votes tr')

			break if trs.length == 0

			trs.each do |tr|
				book_url = tr.css('a.bookTitle').first['href']
				goodreads_id = book_url.split('/').last.to_i

				book = Book.where(goodreads_id: goodreads_id).first
				book ||= Book.create(goodreads_id: goodreads_id)

				GoodreadsListBook.create(
					goodreads_list_id: self.id,
					book_id: book.id,
					rank: tr.css('td.number').first.text.to_i,
					score: tr.css('a:contains("score")').first.text.gsub(/[^\d]/,'').to_i,
					voted: tr.css('a:contains("voted")').first.text.gsub(/[^\d]/,'').to_i
				)
			end

			sleep 5
		end

		self.imported_at = DateTime.now
		self.save

		Rails.logger.info "Imported #{Book.last.id - last_id}/#{self.goodreads_list_books.count} in #{Time.now - t1} seconds"
	end

end
