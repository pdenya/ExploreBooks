class GoodreadsListBooksController < ApplicationController
  before_action :set_goodreads_list_book, only: %i[ show edit update destroy ]

  # GET /goodreads_list_books or /goodreads_list_books.json
  def index
    @goodreads_list_books = GoodreadsListBook.all.page(params[:page] || 1).per(50)
  end

  # GET /goodreads_list_books/1 or /goodreads_list_books/1.json
  def show
  end

  # GET /goodreads_list_books/new
  def new
    @goodreads_list_book = GoodreadsListBook.new
  end

  # GET /goodreads_list_books/1/edit
  def edit
  end

  # POST /goodreads_list_books or /goodreads_list_books.json
  def create
    @goodreads_list_book = GoodreadsListBook.new(goodreads_list_book_params)

    respond_to do |format|
      if @goodreads_list_book.save
        format.html { redirect_to goodreads_list_book_url(@goodreads_list_book), notice: "Goodreads list book was successfully created." }
        format.json { render :show, status: :created, location: @goodreads_list_book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @goodreads_list_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /goodreads_list_books/1 or /goodreads_list_books/1.json
  def update
    respond_to do |format|
      if @goodreads_list_book.update(goodreads_list_book_params)
        format.html { redirect_to goodreads_list_book_url(@goodreads_list_book), notice: "Goodreads list book was successfully updated." }
        format.json { render :show, status: :ok, location: @goodreads_list_book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @goodreads_list_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goodreads_list_books/1 or /goodreads_list_books/1.json
  def destroy
    @goodreads_list_book.destroy

    respond_to do |format|
      format.html { redirect_to goodreads_list_books_url, notice: "Goodreads list book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_goodreads_list_book
      @goodreads_list_book = GoodreadsListBook.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def goodreads_list_book_params
      params.require(:goodreads_list_book).permit(:rank, :book_id, :goodreads_list_id, :score, :voted)
    end
end
