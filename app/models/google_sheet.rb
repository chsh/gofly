class GoogleSheet < ApplicationRecord
  belongs_to :course

  has_many :responses, class_name: "GoogleFormResponse",
           dependent: :destroy

  include GoogleConnectionable
end
