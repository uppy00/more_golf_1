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

ActiveRecord::Schema[7.2].define(version: 2025_07_12_150518) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "post_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "golf_gears", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "club_image"
    t.string "driver_brand"
    t.string "driver_image"
    t.string "iron_brand"
    t.string "iron_image"
    t.string "wedge_brand"
    t.string "wedge_image"
    t.string "putter_brand"
    t.string "putter_image"
    t.string "ball_brand"
    t.string "ball_image"
    t.string "caddy_bag_brand"
    t.string "caddy_bag_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_golf_gears_on_user_id", unique: true
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_likes_on_post_id"
    t.index ["user_id", "post_id"], name: "index_likes_on_user_id_and_post_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "body"
    t.string "image"
    t.bigint "user_id"
    t.bigint "tag_id"
    t.string "postable_type"
    t.bigint "postable_id"
    t.string "video"
    t.index ["postable_type", "postable_id"], name: "index_posts_on_postable"
    t.index ["tag_id"], name: "index_posts_on_tag_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "practice_records", force: :cascade do |t|
    t.string "driving_range_name"
    t.integer "practice_hour"
    t.integer "ball_count"
    t.text "effort_focus"
    t.string "video_reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "score_records", force: :cascade do |t|
    t.string "course_name"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname"
    t.text "self_introduction"
    t.string "favorite_course"
    t.string "favorite_driving_range"
    t.string "driving_range_type"
    t.integer "driving_range_price"
    t.integer "best_score"
    t.string "best_score_course"
    t.string "favorite_video_creator"
    t.string "avatar"
    t.integer "prefecture_id"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "golf_gears", "users"
  add_foreign_key "likes", "posts"
  add_foreign_key "likes", "users"
  add_foreign_key "posts", "tags"
  add_foreign_key "posts", "users"
end
