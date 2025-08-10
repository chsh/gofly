class GoogleFormResponse < ApplicationRecord
  belongs_to :google_form

  concerning :Creatable do
    class_methods do
      def create_from_response(value)
        transaction do
          record = new(response: value)
          record.digest = Digest::SHA256.hexdigest(value.to_s)
          record.submitted_at = value.values.first.in_time_zone
          record.save
          record
        end
      end
    end
  end
end
