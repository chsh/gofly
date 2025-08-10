class GoogleFile < ApplicationRecord
  belongs_to :course

  include GoogleConnectionable
end
