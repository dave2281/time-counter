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

ActiveRecord::Schema[8.0].define(version: 2025_09_29_134718) do
  create_table "daily_logs", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "deed_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "timer_is_active", default: false
    t.index ["deed_id"], name: "index_daily_logs_on_deed_id"
    t.index ["user_id"], name: "index_daily_logs_on_user_id"
  end

  create_table "deeds", force: :cascade do |t|
    t.string "total_time"
    t.string "title", null: false
    t.string "description"
    t.string "color"
    t.boolean "finished", default: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_deeds_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "daily_logs", "deeds"
  add_foreign_key "daily_logs", "users"
  add_foreign_key "deeds", "users"
  add_foreign_key "sessions", "users"
end
