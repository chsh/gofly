# frozen_string_literal: true

class StudentLink
  def initialize(course)
    @course = course
  end
  attr_reader :course

  def link_using_sheet(sheet, code_pos:, list_range:)
    list = sheet.values(list_range)
    return nil if list.blank?
    code = sheet.values(code_pos).flatten.first
    if list.first.first == 'No'
      list.shift # drop first row. (It's header.)
    end
    link_using(code: code, list: list)
  end

  def link_using(code:, list:)
    Course.transaction do
      list.each do |row|
        name, name_reading = row[2].split("\n")
        num = row[0].to_i
        student_id = row[1]
        student = Student.where(id: student_id).
          first_or_create(email: "bu#{student_id}@bukkyo-u.ac.jp",
                          name: name, name_reading: name_reading)
        course.link_student(student, code: code, num: num)
      end
    end
  end
end
