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

ActiveRecord::Schema[8.1].define(version: 2025_11_06_115500) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.integer "pin_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["pin_id"], name: "index_comments_on_pin_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "followed_id", null: false
    t.integer "follower_id", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_follows_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "likes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "pin_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["pin_id"], name: "index_likes_on_pin_id"
    t.index ["user_id", "pin_id"], name: "index_likes_on_user_id_and_pin_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "pins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_pins_on_user_id"
  end

  create_table "reposts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "pin_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["pin_id"], name: "index_reposts_on_pin_id"
    t.index ["user_id", "pin_id"], name: "index_reposts_on_user_id_and_pin_id", unique: true
    t.index ["user_id"], name: "index_reposts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest"
    t.string "string"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "pins"
  add_foreign_key "comments", "users"
  add_foreign_key "follows", "users", column: "followed_id"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "likes", "pins"
  add_foreign_key "likes", "users"
  add_foreign_key "pins", "users"
  add_foreign_key "reposts", "pins"
  add_foreign_key "reposts", "users"
end
