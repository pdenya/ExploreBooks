class BooksController < ApplicationController
	before_action :set_book, only: %i[ show edit update destroy ]
	skip_before_action :verify_authenticity_token, only: [:tags]


	# GET /books or /books.json
	def index
		# quality => "description IS NOT NULL AND genre_names IS NOT NULL AND openlibrary_cover_ids IS NOT NULL"
		quality_params = params[:quality] ? "quality = true" : nil
		book_key = "/books/#{params[:quality] ? "quality" : "index"}"

		# all books
		@books = Book.all
		
		# or start from list
		@books = GoodreadsList.find(params[:goodreads_list_id]).books if params[:goodreads_list_id]
		
		if params[:genres]
			@genre_ids = Genre.where(name: params[:genres]).pluck(:id)

			puts "GENRES #{@genre_ids}"

			if @genre_ids
				book_key = "#{book_key}/genres/#{@genre_ids.join(',')}"

				@books = @books.where(
					'id IN (SELECT book_id from book_genres WHERE genre_id IN (?) GROUP BY book_id HAVING COUNT(book_id) = ?)', 
					@genre_ids, 
					@genre_ids.length
				)
			end
		end
		
		@books = @books.where(quality_params).order('id DESC').page(params[:page] || 1).per(50)
		@books_total_pages = Rails.cache.fetch("#{book_key}/total_pages", expires_in: 1.day) {
			@books.total_pages
		}
		@books_json = Rails.cache.fetch("#{book_key}/page#{params[:page]}", expires_in: 1.day) {
			@books.as_json
		}
	end

	# GET /books/1 or /books/1.json
	def show
	end

	# GET /books/new
	def new
		@book = Book.new
	end

	# GET /books/1/edit
	def edit
	end

	# POST /books or /books.json
	def create
		@book = Book.new(book_params)

		respond_to do |format|
			if @book.save
				format.html { redirect_to book_url(@book), notice: "Book was successfully created." }
				format.json { render :show, status: :created, location: @book }
			else
				format.html { render :new, status: :unprocessable_entity }
				format.json { render json: @book.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /books/1 or /books/1.json
	def update
		respond_to do |format|
			if @book.update(book_params)
				format.html { redirect_to book_url(@book), notice: "Book was successfully updated." }
				format.json { render :show, status: :ok, location: @book }
			else
				format.html { render :edit, status: :unprocessable_entity }
				format.json { render json: @book.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /books/1 or /books/1.json
	def destroy
		@book.destroy

		respond_to do |format|
			format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
			format.json { head :no_content }
		end
	end


	def tags
		@books = Book.all

		if params[:required_genres].present?
			@books = @books.where('id IN (SELECT book_id from book_genres WHERE genre_id IN (?) GROUP BY book_id HAVING COUNT(book_id) = ?)', params[:required_genres], params[:required_genres].length)
		end

		if params[:filtered_genres].present?
			@books = @books.where('id NOT IN (SELECT book_id from book_genres WHERE genre_id IN (?) GROUP BY book_id HAVING COUNT(book_id) > 0)', params[:filtered_genres])
		end

		if params[:min_ratings].present? && params[:min_ratings].to_i > 0
			@books = @books.where('ratings_count > ?', params[:min_ratings])
		end

		if params[:max_ratings].present? && params[:max_ratings].to_i > 0
			@books = @books.where('ratings_count < ?', params[:max_ratings])
		end

		 if params[:min_avg].present? && params[:min_avg].to_d > 0
			@books = @books.where('average_rating > ?', params[:min_avg])
		end

		if params[:max_avg].present? && params[:max_avg].to_d > 0
			@books = @books.where('average_rating < ?', params[:max_avg])
		end

		@total = @books.count
		@books = @books.page(1 || params[:page]).per(20)

		@genres = Genre.joins(:books)
							.select('genres.*, COUNT(books.id) as book_count')
							.group('genres.id')
							.order('book_count DESC')
							.limit(3000)

		@genres = @genres.where("books.id IN (#{@books.select(:id).to_sql})") if @total < 2000

		render json: {
			total: @total,
			genres: @genres,
			books: @books,
			page: @books.current_page,
			total_pages: @books.total_pages,
			page_size: @books.size
		}
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_book
			@book = Book.find(params[:id])
		end

		# Only allow a list of trusted parameters through.
		def book_params
			params.require(:book).permit(:goodreads_id, :title, :authors, :average_rating, :isbn, :isbn13, :language_code, :num_pages, :ratings_count, :text_reviews_count, :publication_date, :publisher, :genres, :description)
		end
end
