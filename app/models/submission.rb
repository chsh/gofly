class Submission < ApplicationRecord
  belongs_to :student
  has_one_attached :file
end
