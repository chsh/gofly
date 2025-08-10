class GoogleSheet < ApplicationRecord
  belongs_to :course

  has_many :responses, class_name: "GoogleFormResponse",
           dependent: :destroy

  concerning :IDGeneratable do
    included do
      validates :url, presence: true
      before_create :parse_url
    end

    private
      def parse_url
        self.id = GoogleService::Connection.new.file_id_from_uri(self.url)
      end
  end
end
