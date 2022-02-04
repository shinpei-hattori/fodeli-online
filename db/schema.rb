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

ActiveRecord::Schema.define(version: 2022_02_01_164208) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "areas", force: :cascade do |t|
    t.string "city"
    t.integer "prefecture_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city"], name: "index_areas_on_city", unique: true
  end

  create_table "chat_posts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "chat_room_id"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_room_id"], name: "index_chat_posts_on_chat_room_id"
    t.index ["user_id", "chat_room_id"], name: "index_chat_posts_on_user_id_and_chat_room_id"
    t.index ["user_id"], name: "index_chat_posts_on_user_id"
  end

  create_table "chat_rooms", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "area_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_chat_rooms_on_area_id"
    t.index ["company_id", "area_id"], name: "index_chat_rooms_on_company_id_and_area_id", unique: true
    t.index ["company_id"], name: "index_chat_rooms_on_company_id"
  end

  create_table "chat_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "chat_room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_room_id"], name: "index_chat_users_on_chat_room_id"
    t.index ["user_id", "chat_room_id"], name: "index_chat_users_on_user_id_and_chat_room_id", unique: true
    t.index ["user_id"], name: "index_chat_users_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "tweet_id"
    t.integer "user_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tweet_id"], name: "index_comments_on_tweet_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "dm_entries", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "dm_room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dm_room_id"], name: "index_dm_entries_on_dm_room_id"
    t.index ["user_id"], name: "index_dm_entries_on_user_id"
  end

  create_table "dm_messages", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "dm_room_id"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dm_room_id"], name: "index_dm_messages_on_dm_room_id"
    t.index ["user_id"], name: "index_dm_messages_on_user_id"
  end

  create_table "dm_rooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tweet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "tweet_id"], name: "index_likes_on_user_id_and_tweet_id", unique: true
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "visitor_id", null: false
    t.integer "visited_id", null: false
    t.integer "tweet_id"
    t.integer "comment_id"
    t.string "action", default: "", null: false
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "chat_post_id"
    t.integer "dm_message_id"
    t.index ["chat_post_id"], name: "index_notifications_on_chat_post_id"
    t.index ["comment_id"], name: "index_notifications_on_comment_id"
    t.index ["dm_message_id"], name: "index_notifications_on_dm_message_id"
    t.index ["tweet_id"], name: "index_notifications_on_tweet_id"
    t.index ["visited_id"], name: "index_notifications_on_visited_id"
    t.index ["visitor_id"], name: "index_notifications_on_visitor_id"
  end

  create_table "prefectures", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_prefectures_on_name", unique: true
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "tweets", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "pictures"
    t.index ["user_id", "created_at"], name: "index_tweets_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_tweets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "introduction"
    t.string "sex"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "image"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chat_posts", "chat_rooms"
  add_foreign_key "chat_posts", "users"
  add_foreign_key "chat_rooms", "areas"
  add_foreign_key "chat_rooms", "companies"
  add_foreign_key "chat_users", "chat_rooms"
  add_foreign_key "chat_users", "users"
  add_foreign_key "dm_entries", "dm_rooms"
  add_foreign_key "dm_entries", "users"
  add_foreign_key "dm_messages", "dm_rooms"
  add_foreign_key "dm_messages", "users"
  add_foreign_key "tweets", "users"
end
