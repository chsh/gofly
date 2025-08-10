# frozen_string_literal: true

class GoogleService::Folder < GoogleService::Base
  concerning :TypeDetectable do
    class_methods do
      def me?(meta)
        meta.mime_type == "application/vnd.google-apps.folder"
      end
    end
  end
end
