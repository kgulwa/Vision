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

ActiveRecord::Schema[8.1].define(version: 2025_12_11_074126) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.uuid "record_id"
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
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

  create_table "collections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
  end

  create_table "comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.uuid "parent_id"
    t.uuid "pin_id"
    t.datetime "updated_at", null: false
    t.uuid "user_id"
  end

  create_table "follows", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "followed_id"
    t.uuid "follower_id"
    t.datetime "updated_at", null: false
  end

  create_table "likes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "pin_id"
    t.datetime "updated_at", null: false
    t.uuid "user_id"
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "action", null: false
    t.uuid "actor_id", null: false
    t.datetime "created_at", null: false
    t.uuid "notifiable_id", null: false
    t.string "notifiable_type", null: false
    t.boolean "read", default: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["actor_id"], name: "index_notifications_on_actor_id"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "pin_tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "pin_id", null: false
    t.uuid "tagged_by_id"
    t.uuid "tagged_user_id", null: false
    t.datetime "updated_at", null: false
    t.index ["pin_id"], name: "index_pin_tags_on_pin_id"
    t.index ["tagged_by_id"], name: "index_pin_tags_on_tagged_by_id"
    t.index ["tagged_user_id"], name: "index_pin_tags_on_tagged_user_id"
  end

  create_table "pins", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "reposts_count"
    t.string "title"
    t.datetime "updated_at", null: false
    t.uuid "user_uid"
  end

  create_table "reposts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "pin_id"
    t.datetime "updated_at", null: false
    t.uuid "user_id"
  end

  create_table "saved_pins", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "collection_id"
    t.datetime "created_at", null: false
    t.uuid "pin_id"
    t.datetime "updated_at", null: false
    t.uuid "user_id"
  end

  create_table "search_histories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "query"
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["user_id"], name: "index_search_histories_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest"
    t.uuid "uid", default: -> { "gen_random_uuid()" }, null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  create_table "video_views", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "duration_seconds"
    t.datetime "ended_at"
    t.uuid "pin_id"
    t.datetime "started_at"
    t.datetime "updated_at", null: false
    t.string "user_uid"
    t.index ["pin_id"], name: "index_video_views_on_pin_id"
    t.index ["user_uid"], name: "index_video_views_on_user_uid"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "collections", "users"
  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "pins"
  add_foreign_key "comments", "users"
  add_foreign_key "follows", "users", column: "followed_id"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "likes", "pins"
  add_foreign_key "likes", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "notifications", "users", column: "actor_id"
  add_foreign_key "pin_tags", "pins"
  add_foreign_key "pin_tags", "users", column: "tagged_by_id"
  add_foreign_key "pin_tags", "users", column: "tagged_user_id"
  add_foreign_key "pins", "users", column: "user_uid", primary_key: "uid"
  add_foreign_key "reposts", "pins"
  add_foreign_key "reposts", "users"
  add_foreign_key "saved_pins", "collections"
  add_foreign_key "saved_pins", "pins"
  add_foreign_key "saved_pins", "users"
  add_foreign_key "search_histories", "users"
end
