# frozen_string_literal: true

class GoogleService::Sheet < GoogleService::Base
  concerning :TypeDetectable do
    class_methods do
      def me?(meta)
        meta.mime_type == "application/vnd.google-apps.spreadsheet"
      end
    end
  end

  def values(range, raw: true)
    response = service.sheets.get_spreadsheet_values id, range
    return response if raw
    response.values
  end
end
