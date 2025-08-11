class CourseStudent < ApplicationRecord
  belongs_to :course
  belongs_to :student

  store_accessor :attrs, :num

  def google_form_responses
    student.google_form_responses.joins(:google_form).merge(GoogleForm.where(course: course)).order(submitted_at: :desc)
  end
end
