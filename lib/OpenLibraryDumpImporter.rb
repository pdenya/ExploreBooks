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
end
