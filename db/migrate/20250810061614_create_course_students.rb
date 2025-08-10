class CreateCourseStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :course_students do |t|
      t.references :course, null: false, foreign_key: true, index: false
      t.references :student, null: false, foreign_key: true, index: false
      t.string :code, null: false
      t.jsonb :attrs, default: {}

      t.timestamps

      t.index [ :course_id, :student_id ], unique: true
      t.index :attrs, using: :gin
    end
  end
end
