require "application_system_test_case"

class GoodreadsListBooksTest < ApplicationSystemTestCase
  setup do
    @goodreads_list_book = goodreads_list_books(:one)
  end

  test "visiting the index" do
    visit goodreads_list_books_url
    assert_selector "h1", text: "Goodreads List Books"
  end

  test "creating a Goodreads list book" do
    visit goodreads_list_books_url
    click_on "New Goodreads List Book"

    fill_in "Book", with: @goodreads_list_book.book_id
    fill_in "Goodreads list", with: @goodreads_list_book.goodreads_list_id
    fill_in "Rank", with: @goodreads_list_book.rank
    fill_in "Score", with: @goodreads_list_book.score
    fill_in "Voted", with: @goodreads_list_book.voted
    click_on "Create Goodreads list book"

    assert_text "Goodreads list book was successfully created"
    click_on "Back"
  end

  test "updating a Goodreads list book" do
    visit goodreads_list_books_url
    click_on "Edit", match: :first

    fill_in "Book", with: @goodreads_list_book.book_id
    fill_in "Goodreads list", with: @goodreads_list_book.goodreads_list_id
    fill_in "Rank", with: @goodreads_list_book.rank
    fill_in "Score", with: @goodreads_list_book.score
    fill_in "Voted", with: @goodreads_list_book.voted
    click_on "Update Goodreads list book"

    assert_text "Goodreads list book was successfully updated"
    click_on "Back"
  end

  test "destroying a Goodreads list book" do
    visit goodreads_list_books_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Goodreads list book was successfully destroyed"
  end
end
