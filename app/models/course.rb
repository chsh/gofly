class Course < ApplicationRecord
  has_many :course_students
  has_many :students, through: :course_students

  has_many :google_sheets, dependent: :destroy
  has_many :google_files, dependent: :destroy
  has_many :google_forms, dependent: :destroy

  concerning :Linkable do
    def link_students_from_result_sheet
      result_sheet = self.google_sheets.find_by(key: "result")
      return nil unless result_sheet
      scan_range = result_sheet.values("A1:D100")
      marks = []
      scan_range.each_with_index do |row, i|
        col_no = row.index("No")
        next unless col_no
        next unless row[col_no+1] == "学籍番号"
        code = scan_range[i-1][col_no]
        if code =~ /^S/
          marks << { code: code, row_start: i + 1, col_start: col_no }
        end
      end
      return nil unless marks.present?
      sl = StudentLink.new(self)
      marks.each do |mark|
        col = mark[:col_start]
        num_index = mark[:row_start]
        list = []
        loop do
          row = scan_range[num_index]
          break if row.nil?
          num = row[col].to_i
          break if num == 0
          student_id = row[col+1]
          student_name_complex = row[col+2]
          list << [ num, student_id, student_name_complex ]
          num_index += 1
        end
        sl.link_using(code: mark[:code], list: list) if list.present?
      end
    end

    def link_student(student, code:, num: nil)
      self.course_students.where(student: student).first_or_create(code: code, num: num)
    end
  end

  scope :recently_created, -> { order(created_at: :desc) }
end
