# frozen_string_literal: true

class GoogleService::File < GoogleService::Base
  concerning :TypeDetectable do
    class_methods do
      def me?(meta)
        meta.kind == "drive#file"
      end
    end
  end

  def download
    sio = StringIO.new
    service.drive.get_file(id, supports_all_drives: true, download_dest: sio)
    sio.string
  end
end
