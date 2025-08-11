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

ActiveRecord::Schema[8.0].define(version: 2025_08_11_001301) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "course_students", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "student_id", null: false
    t.string "code", null: false
    t.jsonb "attrs", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attrs"], name: "index_course_students_on_attrs", using: :gin
    t.index ["course_id", "student_id"], name: "index_course_students_on_course_id_and_student_id", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.string "name", null: false
    t.integer "year", null: false
    t.string "season", null: false
    t.text "description"
    t.jsonb "attrs", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attrs"], name: "index_courses_on_attrs", using: :gin
  end

  create_table "google_files", id: :string, force: :cascade do |t|
    t.bigint "course_id", null: false
    t.string "url", null: false
    t.string "name"
    t.text "description"
    t.jsonb "attrs", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attrs"], name: "index_google_files_on_attrs", using: :gin
    t.index ["course_id"], name: "index_google_files_on_course_id"
  end

  create_table "google_form_responses", force: :cascade do |t|
    t.string "google_form_id", null: false
    t.integer "index", null: false
    t.jsonb "response", null: false
    t.string "digest", null: false
    t.datetime "submitted_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "student_id"
    t.index ["digest"], name: "index_google_form_responses_on_digest"
    t.index ["google_form_id", "index"], name: "index_google_form_responses_on_google_form_id_and_index", unique: true
    t.index ["response"], name: "index_google_form_responses_on_response", using: :gin
    t.index ["student_id"], name: "index_google_form_responses_on_student_id"
    t.index ["submitted_at"], name: "index_google_form_responses_on_submitted_at"
  end

  create_table "google_forms", id: :string, force: :cascade do |t|
    t.bigint "course_id", null: false
    t.string "url", null: false
    t.string "name"
    t.text "description"
    t.jsonb "attrs", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attrs"], name: "index_google_forms_on_attrs", using: :gin
    t.index ["course_id"], name: "index_google_forms_on_course_id"
  end

  create_table "google_sheets", id: :string, force: :cascade do |t|
    t.bigint "course_id", null: false
    t.string "url", null: false
    t.string "name"
    t.text "description"
    t.jsonb "attrs", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attrs"], name: "index_google_sheets_on_attrs", using: :gin
    t.index ["course_id"], name: "index_google_sheets_on_course_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "email", null: false
    t.string "name"
    t.string "name_reading"
    t.text "description"
    t.jsonb "attrs", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attrs"], name: "index_students_on_attrs", using: :gin
    t.index ["email"], name: "index_students_on_email", unique: true
  end

  create_table "submissions", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.string "type"
    t.jsonb "attrs", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_submissions_on_student_id"
    t.index ["type"], name: "index_submissions_on_type"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "course_students", "courses"
  add_foreign_key "course_students", "students"
  add_foreign_key "google_files", "courses"
  add_foreign_key "google_form_responses", "google_forms"
  add_foreign_key "google_form_responses", "students"
  add_foreign_key "google_forms", "courses"
  add_foreign_key "google_sheets", "courses"
  add_foreign_key "submissions", "students"
end
