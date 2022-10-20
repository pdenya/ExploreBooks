# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_10_20_192833) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "book_genres", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "genre_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_id"], name: "index_book_genres_on_book_id"
    t.index ["genre_id"], name: "index_book_genres_on_genre_id"
  end

  create_table "books", force: :cascade do |t|
    t.integer "goodreads_id"
    t.string "title"
    t.string "authors"
    t.decimal "average_rating"
    t.string "isbn"
    t.string "isbn13"
    t.string "language_code"
    t.integer "num_pages"
    t.integer "ratings_count"
    t.integer "text_reviews_count"
    t.date "publication_date"
    t.string "publisher"
    t.string "genres"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "goodreads_list_books", force: :cascade do |t|
    t.integer "rank"
    t.bigint "book_id", null: false
    t.bigint "goodreads_list_id", null: false
    t.integer "score"
    t.integer "voted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_id"], name: "index_goodreads_list_books_on_book_id"
    t.index ["goodreads_list_id"], name: "index_goodreads_list_books_on_goodreads_list_id"
  end

  create_table "goodreads_lists", force: :cascade do |t|
    t.integer "goodreads_id"
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "book_genres", "books"
  add_foreign_key "book_genres", "genres"
  add_foreign_key "goodreads_list_books", "books"
  add_foreign_key "goodreads_list_books", "goodreads_lists"
end
