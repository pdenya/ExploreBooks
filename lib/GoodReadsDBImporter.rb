class GoodReadsDBImporter
	def go
		require 'csv'

		data = CSV.read("./books.csv", liberal_parsing: true)

		headers = data.first.map(&:trim)
		headers[0] = "goodreads_id"

		data.each_with_index do |row, index|
			next if index < 2


			book = Book.new
			headers.each_with_index do |header, hindex|
				book[header] = row[hindex]
			end

			book.save

		end
	end
end