require "test_helper"

class GoodreadsListBooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @goodreads_list_book = goodreads_list_books(:one)
  end

  test "should get index" do
    get goodreads_list_books_url
    assert_response :success
  end

  test "should get new" do
    get new_goodreads_list_book_url
    assert_response :success
  end

  test "should create goodreads_list_book" do
    assert_difference('GoodreadsListBook.count') do
      post goodreads_list_books_url, params: { goodreads_list_book: { book_id: @goodreads_list_book.book_id, goodreads_list_id: @goodreads_list_book.goodreads_list_id, rank: @goodreads_list_book.rank, score: @goodreads_list_book.score, voted: @goodreads_list_book.voted } }
    end

    assert_redirected_to goodreads_list_book_url(GoodreadsListBook.last)
  end

  test "should show goodreads_list_book" do
    get goodreads_list_book_url(@goodreads_list_book)
    assert_response :success
  end

  test "should get edit" do
    get edit_goodreads_list_book_url(@goodreads_list_book)
    assert_response :success
  end

  test "should update goodreads_list_book" do
    patch goodreads_list_book_url(@goodreads_list_book), params: { goodreads_list_book: { book_id: @goodreads_list_book.book_id, goodreads_list_id: @goodreads_list_book.goodreads_list_id, rank: @goodreads_list_book.rank, score: @goodreads_list_book.score, voted: @goodreads_list_book.voted } }
    assert_redirected_to goodreads_list_book_url(@goodreads_list_book)
  end

  test "should destroy goodreads_list_book" do
    assert_difference('GoodreadsListBook.count', -1) do
      delete goodreads_list_book_url(@goodreads_list_book)
    end

    assert_redirected_to goodreads_list_books_url
  end
end
