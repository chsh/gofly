class Course < ApplicationRecord
  has_many :course_students
  has_many :students, through: :course_students

  concerning :Linkable do
    def link_student(student, code)
      self.course_students.where(student: student).first_or_create(code: code)
    end
  end
end
