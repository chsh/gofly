concern :GoogleConnectionable do
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
      self.name = GoogleService::Connection.new.get_meta(self.id).name
    end
end

