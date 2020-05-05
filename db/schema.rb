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

ActiveRecord::Schema.define(version: 2020_05_05_170229) do

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

  create_table "actuals", force: :cascade do |t|
    t.integer "meta_id"
    t.integer "user_id"
    t.json "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.index ["uuid"], name: "index_actuals_on_uuid", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.integer "parent_id"
    t.integer "commentable_id"
    t.string "commentable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_id"], name: "index_comments_on_commentable_id"
    t.index ["commentable_type"], name: "index_comments_on_commentable_type"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "devices", force: :cascade do |t|
    t.integer "user_id"
    t.text "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "title"
    t.integer "user_id"
    t.json "grouping"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "involvements", force: :cascade do |t|
    t.integer "user_id"
    t.integer "involveable_id"
    t.string "involoveable_type"
    t.string "status"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "involveable_type"
    t.index ["involveable_id"], name: "index_involvements_on_involveable_id"
    t.index ["involveable_type"], name: "index_involvements_on_involveable_type"
    t.index ["user_id"], name: "index_involvements_on_user_id"
  end

  create_table "meta", force: :cascade do |t|
    t.string "meta_type"
    t.integer "user_id"
    t.json "meta_schema"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "label"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.integer "source_user_id"
    t.json "target_user_ids"
    t.string "notification_type"
    t.boolean "seen"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "custom_text"
    t.index ["notifiable_id"], name: "index_notifications_on_notifiable_id"
    t.index ["notifiable_type"], name: "index_notifications_on_notifiable_type"
    t.index ["notification_type"], name: "index_notifications_on_notification_type"
    t.index ["source_user_id"], name: "index_notifications_on_source_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.string "surename"
    t.string "mobile"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.json "experties"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.json "draft"
    t.integer "user_id"
    t.integer "task_id"
    t.integer "work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.index ["task_id"], name: "index_reports_on_task_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
    t.index ["uuid"], name: "index_reports_on_uuid"
    t.index ["work_id"], name: "index_reports_on_work_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "title"
    t.json "ability"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.boolean "default_role"
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "private"
    t.json "notification_setting"
    t.json "blocked_list"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "title"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_statuses_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "title"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "details"
    t.integer "occurrence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start"
    t.datetime "deadline"
    t.integer "user_id"
    t.json "participants"
    t.integer "status_id"
    t.boolean "public"
    t.json "tags"
    t.boolean "archived"
    t.text "archive_note"
    t.index ["status_id"], name: "index_tasks_on_status_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "time_sheets", force: :cascade do |t|
    t.integer "user_id"
    t.text "morning_report"
    t.text "afternoon_report"
    t.text "extra_report"
    t.json "associations"
    t.json "recipients"
    t.date "sheet_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_time_sheets_on_user_id"
  end

  create_table "todos", force: :cascade do |t|
    t.string "title"
    t.integer "work_id"
    t.json "participants"
    t.boolean "is_done"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_todos_on_user_id"
    t.index ["work_id"], name: "index_todos_on_work_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.index ["uuid"], name: "index_uploads_on_uuid"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "assignments"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "last_code"
    t.datetime "last_code_datetime"
    t.datetime "last_login"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.integer "visitable_id"
    t.string "visitable_type"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "visitable_action"
    t.json "the_params"
    t.index ["user_id"], name: "index_visits_on_user_id"
    t.index ["visitable_action"], name: "index_visits_on_visitable_action"
    t.index ["visitable_id"], name: "index_visits_on_visitable_id"
    t.index ["visitable_type"], name: "index_visits_on_visitable_type"
  end

  create_table "works", force: :cascade do |t|
    t.string "title"
    t.string "details"
    t.integer "user_id"
    t.integer "task_id"
    t.datetime "start"
    t.datetime "deadline"
    t.integer "status_id"
    t.json "statuses"
    t.json "participants"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "priority"
    t.boolean "archived"
    t.index ["status_id"], name: "index_works_on_status_id"
    t.index ["task_id"], name: "index_works_on_task_id"
    t.index ["user_id"], name: "index_works_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
