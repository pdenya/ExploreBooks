require "application_system_test_case"

class BookGenresTest < ApplicationSystemTestCase
  setup do
    @book_genre = book_genres(:one)
  end

  test "visiting the index" do
    visit book_genres_url
    assert_selector "h1", text: "Book Genres"
  end

  test "creating a Book genre" do
    visit book_genres_url
    click_on "New Book Genre"

    fill_in "Book", with: @book_genre.book_id
    fill_in "Genre", with: @book_genre.genre_id
    click_on "Create Book genre"

    assert_text "Book genre was successfully created"
    click_on "Back"
  end

  test "updating a Book genre" do
    visit book_genres_url
    click_on "Edit", match: :first

    fill_in "Book", with: @book_genre.book_id
    fill_in "Genre", with: @book_genre.genre_id
    click_on "Update Book genre"

    assert_text "Book genre was successfully updated"
    click_on "Back"
  end

  test "destroying a Book genre" do
    visit book_genres_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Book genre was successfully destroyed"
  end
end
