class OpenLibraryDumpImporter
	def go
		infile = open("ol_dump_2022-10-31.txt.gz")
		gz = Zlib::GzipReader.new(infile)

		lines = []
		skipped = 0
		prev_imported = 0
		imported = 0
		errors = 0
		t1 = Time.now

		gz.each_line do |line|
			l = line.split("\t")
			if l.first == "/type/work"
				begin
					book = Book.import_from_openlibrary(JSON.parse(l.last))
					if book
						imported += 1
						puts "Skipped: #{skipped}, Imported: #{imported}, PrevImported: #{prev_imported}, Errors: #{errors}, Time: #{Time.now - t1}" if imported % 500 == 0
					else
						prev_imported += 1
						puts "Skipped: #{skipped}, Imported: #{imported}, PrevImported: #{prev_imported}, Errors: #{errors}, Time: #{Time.now - t1}" if prev_imported % 10000 == 0
					end

				rescue => e
					errors += 1
					Rails.logger.error(e.message)
					Rails.logger.error(e.backtrace)
					puts "Skipped: #{skipped}, Imported: #{imported}, PrevImported: #{prev_imported}, Errors: #{errors}, Time: #{Time.now - t1}" if errors % 100 == 0
				end
			else
				skipped += 1
			end
		end
		ap lines
		puts "#{skipped} skipped"

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
end
