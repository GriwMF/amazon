# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140307150419) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.string   "address"
    t.string   "zipcode"
    t.string   "city"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
  end

  add_index "addresses", ["country"], name: "index_addresses_on_country", using: :btree

  create_table "authors", force: true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "authors", ["firstname", "lastname"], name: "index_authors_on_firstname_and_lastname", using: :btree

  create_table "authors_books", id: false, force: true do |t|
    t.integer "book_id",   null: false
    t.integer "author_id", null: false
  end

  add_index "authors_books", ["author_id", "book_id"], name: "index_authors_books_on_author_id_and_book_id", using: :btree
  add_index "authors_books", ["book_id", "author_id"], name: "index_authors_books_on_book_id_and_author_id", using: :btree

  create_table "books", force: true do |t|
    t.string   "title"
    t.decimal  "price",            precision: 8, scale: 2
    t.integer  "in_stock"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shot"
    t.text     "full_description"
    t.text     "description"
  end

  create_table "books_categories", id: false, force: true do |t|
    t.integer "book_id",     null: false
    t.integer "category_id", null: false
  end

  add_index "books_categories", ["book_id", "category_id"], name: "index_books_categories_on_book_id_and_category_id", using: :btree
  add_index "books_categories", ["category_id", "book_id"], name: "index_books_categories_on_category_id_and_book_id", using: :btree

  create_table "books_customers", id: false, force: true do |t|
    t.integer "book_id",     null: false
    t.integer "customer_id", null: false
  end

  add_index "books_customers", ["book_id", "customer_id"], name: "index_books_customers_on_book_id_and_customer_id", using: :btree
  add_index "books_customers", ["customer_id", "book_id"], name: "index_books_customers_on_customer_id_and_book_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_cards", force: true do |t|
    t.string   "number"
    t.integer  "cvv"
    t.integer  "expiration_month"
    t.integer  "expiration_year"
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credit_cards", ["customer_id"], name: "index_credit_cards_on_customer_id", using: :btree

  create_table "customers", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "firstname"
    t.string   "lastname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.integer  "bill_addr_id"
    t.integer  "ship_addr_id"
  end

  add_index "customers", ["email"], name: "index_customers_on_email", unique: true, using: :btree
  add_index "customers", ["firstname", "lastname"], name: "index_customers_on_firstname_and_lastname", using: :btree
  add_index "customers", ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true, using: :btree

  create_table "order_items", force: true do |t|
    t.decimal  "price",      precision: 8, scale: 2
    t.integer  "quantity"
    t.integer  "book_id"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_items", ["book_id"], name: "index_order_items_on_book_id", using: :btree
  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id", using: :btree

  create_table "orders", force: true do |t|
    t.decimal  "total_price",    precision: 8, scale: 2
    t.string   "state"
    t.datetime "completed_at"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "credit_card_id"
  end

  add_index "orders", ["credit_card_id"], name: "index_orders_on_credit_card_id", using: :btree
  add_index "orders", ["customer_id"], name: "index_orders_on_customer_id", using: :btree

  create_table "ratings", force: true do |t|
    t.integer  "rating",      limit: 2
    t.string   "text"
    t.integer  "book_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                 default: "pending"
  end

  add_index "ratings", ["book_id"], name: "index_ratings_on_book_id", using: :btree
  add_index "ratings", ["customer_id"], name: "index_ratings_on_customer_id", using: :btree

end
