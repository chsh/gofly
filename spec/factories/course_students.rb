FactoryBot.define do
  factory :course_student do
    course
    student
    code { "LS25012A" }
  end
end
