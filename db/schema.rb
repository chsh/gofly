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

ActiveRecord::Schema[8.0].define(version: 2025_08_10_061614) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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

  create_table "students", force: :cascade do |t|
    t.string "email", null: false
    t.string "name"
    t.string "name_reading"
    t.jsonb "attrs", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attrs"], name: "index_students_on_attrs", using: :gin
    t.index ["email"], name: "index_students_on_email", unique: true
  end

  add_foreign_key "course_students", "courses"
  add_foreign_key "course_students", "students"
end
