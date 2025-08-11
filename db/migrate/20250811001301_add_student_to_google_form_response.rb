class AddStudentToGoogleFormResponse < ActiveRecord::Migration[8.0]
  def change
    add_reference :google_form_responses, :student, null: true, foreign_key: true, index: true
  end
end
