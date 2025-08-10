class GoogleForm < ApplicationRecord
  belongs_to :course

  has_many :responses, class_name: "GoogleFormResponse",
           dependent: :destroy

  concerning :IDGeneratable do
    included do
      validates :url, presence: true
      before_create :parse_url_and_set_name
    end

    private
      def parse_url_and_set_name
        parse_url
        set_name
      end

      def parse_url
        self.id = GoogleService::Connection.new.file_id_from_uri(self.url)
      end

      def set_name
        self.name = GoogleService::Connection.new.get_object(self.id).meta.name
      end
  end

  concerning :ResponseCrawlable do
    included do
      store_accessor :attrs,
                     :response_header, :response_header_map
    end
    def crawl_responses
      sheet_object = GoogleService::Connection.new.get_object(self.id)
      values = sheet_object.values("A1:I149", raw: false)
      header = values.shift
      values.each_with_index do |row, index|
        sheet_index = index + 1
        response = build_response_from(header, row)
        ar = self.responses.where(index: sheet_index)
        transaction do
          ar.first || ar.create_from_response(response)
        end
      end
      update response_header: header
    end

    private
      def build_response_from(header, row)
        header.map.with_index { |h, i| [ h, row[i] ] }.to_h
      end
  end
end
