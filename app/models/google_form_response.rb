class GoogleFormResponse < ApplicationRecord
  belongs_to :google_form
  belongs_to :student, optional: true

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

  delegate :course, to: :google_form

  concerning :GoogleFileDeetectable do
    def google_file
      return @google_file if defined? @google_file
      @google_file = scan_google_file_from_response
    end

    private
      def scan_google_file_from_response
        con = GoogleService::Connection.new
        self.response.values.each do |value|
          file_id = con.file_id_from_uri(value)
          return con.get_object(file_id) if file_id.present?
        end
        nil
      end
  end
end
