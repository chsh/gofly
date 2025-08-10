class GoogleFile < ApplicationRecord
  belongs_to :course

  include GoogleConnectionable

  def download
    sio = StringIO.new
    google_connection.drive.get_file(id, supports_all_drives: true, download_dest: sio)
    sio.string
  end
end
