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

ActiveRecord::Schema.define(version: 2018_11_19_101157) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "location"
    t.datetime "start_date"
    t.datetime "end_date"
    t.uuid "user_id"
    t.integer "priority"
    t.string "google_event_id"
    t.integer "event_type"
    t.uuid "goal_id"
    t.integer "creation_source", default: 0
    t.index ["goal_id"], name: "index_events_on_goal_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "goals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "picture"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "goal_type"
    t.text "s"
    t.text "m"
    t.text "a"
    t.text "r"
    t.text "t"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "sync_logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "time"
    t.string "calendar_id"
    t.string "event_id"
    t.integer "status"
    t.string "reason"
    t.uuid "user_id"
    t.index ["user_id"], name: "index_sync_logs_on_user_id"
  end

  create_table "tasks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.integer "status"
    t.uuid "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_tasks_on_event_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "last_name"
    t.string "token"
    t.string "refresh_token"
    t.datetime "expires_at"
    t.string "working_start_time", default: "08:00:00"
    t.string "working_end_time", default: "21:00:00"
    t.boolean "sync_enabled", default: false
    t.integer "default_events_type", default: 0
    t.integer "default_events_priority", default: 0
  end

  add_foreign_key "goals", "users"
  add_foreign_key "sync_logs", "users"
  add_foreign_key "tasks", "events"
end
