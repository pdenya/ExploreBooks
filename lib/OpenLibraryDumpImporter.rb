class OpenLibraryDumpImporter

	def update_works
		ActiveRecord::Base.logger.level = 1 # or Logger::INFO

		infile = open("ol_dump_2022-10-31.txt.gz")
		gz = Zlib::GzipReader.new(infile)

		skipped = 0
		no_change = 0
		imported = 0
		errors = 0
		t1 = Time.now
		works = []

		gz.each_line do |line|
			l = line.split("\t")
			if l.first == "/type/work"
				works << JSON.parse(l.last)
			else
				skipped += 1
				puts "Skipped: #{skipped}, Imported: #{imported}, Errors #{errors} Time: #{Time.now - t1}" if skipped % 20000 == 0
			end

			if works.length >= 500
				Book.transaction do
					books = Book.where(openlibrary_id: works.map{ |work| work['key'] }.compact).index_by(&:openlibrary_id)

					works.each do |work|
						book = self.update_book_from_openlibrary(work, books[work['key']])

						if book && book.saved_changes?
							imported += 1
							puts "Skipped: #{skipped}, Imported: #{imported}, No Change: #{no_change}, Errors #{errors} Time: #{Time.now - t1}" if imported % 10000 == 0
						elsif book
							no_change += 1
							puts "Skipped: #{skipped}, Imported: #{imported}, No Change: #{no_change}, Errors #{errors} Time: #{Time.now - t1}" if no_change % 10000 == 0
						else
							errors += 1
						end						
					end

					works = []
				end
			end
		end

		puts "Skipped: #{skipped}, Imported: #{imported}, No Change: #{no_change}, Errors #{errors} Time: #{Time.now - t1}"

		infile.close
	end

	def import_editions
		ActiveRecord::Base.logger.level = 1 # or Logger::INFO

		infile = open("ol_dump_2022-10-31.txt.gz")
		gz = Zlib::GzipReader.new(infile)

		skipped = 0
		no_change = 0
		imported = 0
		errors = 0
		t1 = Time.now
		editions = []

		gz.each_line do |line|
			l = line.split("\t")
			if l.first == "/type/edition"
				editions << JSON.parse(l.last)
			else
				skipped += 1
				puts "Skipped: #{skipped}, Imported: #{imported}, Errors #{errors} Time: #{Time.now - t1}" if skipped % 20000 == 0
			end

			if editions.length >= 500
				Book.transaction do
					books = Book.where(openlibrary_id: editions.map{ |e| self.get_book_id_from_openlibrary_edition(e) }.compact).index_by(&:openlibrary_id)

					editions.each do |edition|
						book = self.update_book_with_openlibrary_edition(edition, books[self.get_book_id_from_openlibrary_edition(edition)])
						if book && book.saved_changes?
							imported += 1
							puts "Skipped: #{skipped}, Imported: #{imported}, No Change: #{no_change}, Errors #{errors} Time: #{Time.now - t1}" if imported % 10000 == 0
						elsif book
							no_change += 1
							puts "Skipped: #{skipped}, Imported: #{imported}, No Change: #{no_change}, Errors #{errors} Time: #{Time.now - t1}" if no_change % 10000 == 0
						else
							errors += 1
						end						
					end

					editions = []
				end
			end
		end

		puts "Skipped: #{skipped}, Imported: #{imported}, No Change: #{no_change}, Errors #{errors} Time: #{Time.now - t1}"

		infile.close
	end

	def go_genres
		t1 = Time.now
		max_id = BookGenre.order('book_id DESC').first.book_id
		remaining_count = Book.where('id > ?', max_id).count
		while remaining_count > 0 do
			max_id = BookGenre.order('book_id DESC').first.book_id
			remaining_count = Book.where('id > ?', max_id).count
			puts "Books Remaining: #{remaining_count}, Time: #{Time.now - t1}"
			self.process_genres_batch
		end
	end

	def process_genres_batch
		max_id = BookGenre.order('book_id DESC').first.book_id

		books = Book.where('id > ?', max_id).order('id ASC').first(250)

		genres = Genre.where(name: books.map{ |b| b.genre_names.split('|') }.flatten.uniq)
		genre_name_id_map = {}
		genres.each { |g| genre_name_id_map[g.name] = g.id }

		book_genre_inserts = []

		books.each do |book|
			book.genre_names.split('|').each do |gn|
				# create genre if missing
				unless genre_name_id_map[gn]
					new_genre = Genre.create(name: gn)
					genre_name_id_map[new_genre.name] = new_genre.id
				end

				book_genre_inserts << {
					book_id: book.id,
					genre_id: genre_name_id_map[gn],
					created_at: DateTime.now,
					updated_at: DateTime.now,
				}
			end
		end

		BookGenre.insert_all(book_genre_inserts)
	end

	def update_book_from_openlibrary(ol_work, book)
		return unless book && ol_work['authors']

		authors = ol_work['authors'].map{ |author|  author['author'].is_a?(String) ? author['author'] : author.dig('author','key') }.flatten.compact
		authors = authors.concat(book.authors.split('|')).uniq if book.authors

		book.authors = authors.join('|') if authors

		book.save!
		
		book
	end

	def get_book_id_from_openlibrary_edition(ol_edition)
		return unless ol_edition && ol_edition['works']
		ol_id = self.ol_string(ol_edition['works'])
		ol_id.is_a?(String) ? ol_id : ol_id['key']
	end

	def update_book_with_openlibrary_edition(ol_edition, book)
		return unless book

		book.isbn10s << self.ol_string(ol_edition['isbn_10']) if ol_edition['isbn_10']
		book.isbn13s << self.ol_string(ol_edition['isbn_13']) if ol_edition['isbn_13']
		book.publishers << self.ol_string(ol_edition['publishers']) if ol_edition['publishers']
		book.ol_sources.push(*ol_edition['source_records']) if ol_edition['source_records']

		book.isbn10s.uniq!
		book.isbn13s.uniq!
		book.publishers.uniq!
		book.ol_sources.uniq!

		book.isbn10s.compact!
		book.isbn13s.compact!
		book.publishers.compact!
		book.ol_sources.compact!

		book.save!

		book
	end

	def ol_string(ol_object)
		ol_object.is_a?(String) ? ol_object : ol_object.first
	end

	def fix_import_dates
		ActiveRecord::Base.connection.execute(
			"UPDATE books SET publication_date=created_at WHERE id IN (SELECT id FROM books WHERE publication_date IS NULL AND openlibrary_id IS NOT NULL LIMIT 100000)"
		)
	end
end
