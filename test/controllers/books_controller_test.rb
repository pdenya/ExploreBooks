require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:one)
  end

  test "should get index" do
    get books_url
    assert_response :success
  end

  test "should get new" do
    get new_book_url
    assert_response :success
  end

  test "should create book" do
    assert_difference('Book.count') do
      post books_url, params: { book: { authors: @book.authors, average_rating: @book.average_rating, description: @book.description, genres: @book.genres, goodreads_id: @book.goodreads_id, isbn: @book.isbn, isbn13: @book.isbn13, language_code: @book.language_code, num_pages: @book.num_pages, publication_date: @book.publication_date, publisher: @book.publisher, ratings_count: @book.ratings_count, text_reviews_count: @book.text_reviews_count, title: @book.title } }
    end

    assert_redirected_to book_url(Book.last)
  end

  test "should show book" do
    get book_url(@book)
    assert_response :success
  end

  test "should get edit" do
    get edit_book_url(@book)
    assert_response :success
  end

  test "should update book" do
    patch book_url(@book), params: { book: { authors: @book.authors, average_rating: @book.average_rating, description: @book.description, genres: @book.genres, goodreads_id: @book.goodreads_id, isbn: @book.isbn, isbn13: @book.isbn13, language_code: @book.language_code, num_pages: @book.num_pages, publication_date: @book.publication_date, publisher: @book.publisher, ratings_count: @book.ratings_count, text_reviews_count: @book.text_reviews_count, title: @book.title } }
    assert_redirected_to book_url(@book)
  end

  test "should destroy book" do
    assert_difference('Book.count', -1) do
      delete book_url(@book)
    end

    assert_redirected_to books_url
  end
end
