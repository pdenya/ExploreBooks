class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token, only: [:tags]


  # GET /books or /books.json
  def index
    if params[:goodreads_list_id]
      @books = GoodreadsList.find(params[:goodreads_list_id]).books
    else
      @books = Book.all.page(params[:page] || 1).per(50)
    end
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
    @books = Book.where('ratings_count > 50')

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

    @books = @books.page(1 || params[:page]).per(20)

    @total = @books.count

    @genres = Genre.joins(:books)
              .where('books.ratings_count > 50')
              .select('genres.*, COUNT(books.id) as book_count')
              .group('genres.id')
              .order('book_count DESC')

    @genres = @genres.where("books.id IN (#{@books.select(:id).to_sql})")

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
