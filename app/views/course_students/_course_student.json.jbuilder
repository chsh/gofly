json.extract! course_student, :id, :course_id, :student_id, :code, :attrs, :created_at, :updated_at
json.url course_student_url(course_student, format: :json)
