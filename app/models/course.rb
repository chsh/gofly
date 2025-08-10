class Course < ApplicationRecord
  has_many :course_students
  has_many :students, through: :course_students

  has_many :google_sheets, dependent: :destroy
  has_many :google_files, dependent: :destroy
  has_many :google_forms, dependent: :destroy

  concerning :Linkable do
    def link_student(student, code:, num: nil)
      self.course_students.where(student: student).first_or_create(code: code, num: num)
    end
  end

  scope :recently_created, -> { order(created_at: :desc) }
end
