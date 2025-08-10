concern :GoogleConnectionable do
  included do
    validates :url, presence: true
    before_create :parse_url_and_set_name
  end

  def google_connection
    @google_connection ||= GoogleService::Connection.new
  end

  def meta
    @meta ||= google_connection.get_meta(self.id)
  end

  private
    def parse_url_and_set_name
      parse_url
      set_name
    end

    def parse_url
      self.id = google_connection.file_id_from_uri(self.url)
    end

    def set_name
      self.name = meta.name
    end
end
