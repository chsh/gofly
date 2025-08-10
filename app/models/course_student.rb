class CourseStudent < ApplicationRecord
  belongs_to :course
  belongs_to :student

  store_accessor :attrs, :num
end
