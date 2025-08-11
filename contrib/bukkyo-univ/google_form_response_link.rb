# frozen_string_literal: true

class GoogleFormResponseLink
  def initialize(google_form)
    @google_form = google_form
  end
  attr_reader :google_form

  def link_all_to_student
    google_form.responses.each do |response|
      email = response.response["メールアドレス"]
      student = Student.find_by(email: email)
      if student.present?
        response.update student: student
        puts "found and linked: #{student.name} (#{email})"
      else
        puts "not found: (#{email})"
      end
    end
  end
end
