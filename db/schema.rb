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

ActiveRecord::Schema.define(version: 20161112144855) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dismissals", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "dismissed_user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["dismissed_user_id"], name: "index_dismissals_on_dismissed_user_id", using: :btree
    t.index ["user_id", "dismissed_user_id"], name: "index_dismissals_on_user_id_and_dismissed_user_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_dismissals_on_user_id", using: :btree
  end

  create_table "loves", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "loved_user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["loved_user_id"], name: "index_loves_on_loved_user_id", using: :btree
    t.index ["user_id", "loved_user_id"], name: "index_loves_on_user_id_and_loved_user_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_loves_on_user_id", using: :btree
  end

  create_table "matches", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "matched_user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["matched_user_id"], name: "index_matches_on_matched_user_id", using: :btree
    t.index ["user_id", "matched_user_id"], name: "index_matches_on_user_id_and_matched_user_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_matches_on_user_id", using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id",                            null: false
    t.integer  "triggering_user_id"
    t.integer  "love_id"
    t.integer  "match_id"
    t.text     "content",                            null: false
    t.text     "email_subject",                      null: false
    t.text     "email_content"
    t.text     "push_subject"
    t.text     "push_content"
    t.text     "facebook_content"
    t.boolean  "read",               default: false, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["love_id"], name: "index_notifications_on_love_id", using: :btree
    t.index ["match_id"], name: "index_notifications_on_match_id", using: :btree
    t.index ["read"], name: "index_notifications_on_read", using: :btree
    t.index ["triggering_user_id"], name: "index_notifications_on_triggering_user_id", using: :btree
    t.index ["user_id", "read"], name: "index_notifications_on_user_id_and_read", using: :btree
    t.index ["user_id"], name: "index_notifications_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                      default: "",    null: false
    t.string   "encrypted_password",         default: "",    null: false
    t.string   "first_name",                                 null: false
    t.string   "last_name",                                  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "facebook_image_url"
    t.string   "profile_image_file_name"
    t.string   "profile_image_content_type"
    t.integer  "profile_image_file_size"
    t.datetime "profile_image_updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.boolean  "follower"
    t.boolean  "leader"
    t.boolean  "admin",                      default: false, null: false
    t.string   "facebook_token"
    t.integer  "radius",                     default: 22000, null: false
    t.boolean  "active",                     default: true,  null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["follower"], name: "index_users_on_follower", using: :btree
    t.index ["leader"], name: "index_users_on_leader", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "dismissals", "users"
  add_foreign_key "dismissals", "users", column: "dismissed_user_id"
  add_foreign_key "loves", "users"
  add_foreign_key "loves", "users", column: "loved_user_id"
  add_foreign_key "matches", "users"
  add_foreign_key "matches", "users", column: "matched_user_id"
  add_foreign_key "notifications", "loves", column: "love_id"
  add_foreign_key "notifications", "matches"
  add_foreign_key "notifications", "users"
  add_foreign_key "notifications", "users", column: "triggering_user_id"
end
