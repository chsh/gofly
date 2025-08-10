# frozen_string_literal: true

class GoogleService::Sheet < GoogleService::Base
  concerning :TypeDetectable do
    class_methods do
      def me?(meta)
        meta.mime_type == "application/vnd.google-apps.spreadsheet"
      end
    end
  end
end
