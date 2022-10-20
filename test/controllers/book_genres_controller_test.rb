require "test_helper"

class BookGenresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book_genre = book_genres(:one)
  end

  test "should get index" do
    get book_genres_url
    assert_response :success
  end

  test "should get new" do
    get new_book_genre_url
    assert_response :success
  end

  test "should create book_genre" do
    assert_difference('BookGenre.count') do
      post book_genres_url, params: { book_genre: { book_id: @book_genre.book_id, genre_id: @book_genre.genre_id } }
    end

    assert_redirected_to book_genre_url(BookGenre.last)
  end

  test "should show book_genre" do
    get book_genre_url(@book_genre)
    assert_response :success
  end

  test "should get edit" do
    get edit_book_genre_url(@book_genre)
    assert_response :success
  end

  test "should update book_genre" do
    patch book_genre_url(@book_genre), params: { book_genre: { book_id: @book_genre.book_id, genre_id: @book_genre.genre_id } }
    assert_redirected_to book_genre_url(@book_genre)
  end

  test "should destroy book_genre" do
    assert_difference('BookGenre.count', -1) do
      delete book_genre_url(@book_genre)
    end

    assert_redirected_to book_genres_url
  end
end
