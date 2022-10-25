require "application_system_test_case"

class BooksTest < ApplicationSystemTestCase
  setup do
    @book = books(:one)
  end

  test "visiting the index" do
    visit books_url
    assert_selector "h1", text: "Books"
  end

  test "creating a Book" do
    visit books_url
    click_on "New Book"

    fill_in "Authors", with: @book.authors
    fill_in "Average rating", with: @book.average_rating
    fill_in "Description", with: @book.description
    fill_in "Genres", with: @book.genres
    fill_in "Goodreads", with: @book.goodreads_id
    fill_in "Isbn", with: @book.isbn
    fill_in "Isbn13", with: @book.isbn13
    fill_in "Language code", with: @book.language_code
    fill_in "Num pages", with: @book.num_pages
    fill_in "Publication date", with: @book.publication_date
    fill_in "Publisher", with: @book.publisher
    fill_in "Ratings count", with: @book.ratings_count
    fill_in "Text reviews count", with: @book.text_reviews_count
    fill_in "Title", with: @book.title
    click_on "Create Book"

    assert_text "Book was successfully created"
    click_on "Back"
  end

  test "updating a Book" do
    visit books_url
    click_on "Edit", match: :first

    fill_in "Authors", with: @book.authors
    fill_in "Average rating", with: @book.average_rating
    fill_in "Description", with: @book.description
    fill_in "Genres", with: @book.genre_names
    fill_in "Goodreads", with: @book.goodreads_id
    fill_in "Isbn", with: @book.isbn
    fill_in "Isbn13", with: @book.isbn13
    fill_in "Language code", with: @book.language_code
    fill_in "Num pages", with: @book.num_pages
    fill_in "Publication date", with: @book.publication_date
    fill_in "Publisher", with: @book.publisher
    fill_in "Ratings count", with: @book.ratings_count
    fill_in "Text reviews count", with: @book.text_reviews_count
    fill_in "Title", with: @book.title
    click_on "Update Book"

    assert_text "Book was successfully updated"
    click_on "Back"
  end

  test "destroying a Book" do
    visit books_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Book was successfully destroyed"
  end
end
