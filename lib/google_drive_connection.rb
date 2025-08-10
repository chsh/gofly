# frozen_string_literal: true

class GoogleDriveConnection

  def get_file_from_url(url)
    uri = URI.parse(url)
    file_id = file_id_from_uri(uri)
    return nil if file_id.blank?
    get_file(file_id)
  end

  def get_file(file_id)
    begin
      meta = drive.get_file(file_id, supports_all_drives: true)
      sio = StringIO.new
      drive.get_file(file_id, supports_all_drives: true, download_dest: sio)
      {
        meta: meta.to_h,
        content: sio.string
      }
    rescue
      nil
    end
  end

  def get_folder(folder_id)
    query = "'#{folder_id}' in parents and trashed = false"
    drive.list_files q: query, fields: "files(id, kind, mime_type, name, createdTime, modifiedTime)"
  end

  def drive
    @drive ||= begin
      authorizer = new_authorizer
      authorizer.fetch_access_token!
      drive = Google::Apis::DriveV3::DriveService.new
      drive.authorization = authorizer
      drive
    end
  end
  alias_method :client, :drive

  private
    def service_account_credential_io
      s3 = S3File.new
      content = s3.get("system/google-service-account-credential.json")
      StringIO.new(content)
    end

    def new_authorizer
      Google::Auth::ServiceAccountCredentials.
        make_creds(
          json_key_io: service_account_credential_io,
          scope: Google::Apis::DriveV3::AUTH_DRIVE_READONLY)
    end

    def file_id_from_uri(uri)
      return nil unless uri.scheme == "https"
      return nil unless uri.host == "drive.google.com"
      return $1 if uri.path =~ /\/d\/(.+?)\//
      return $1 if uri.query =~ /\bd=(.+?)\b/
      return $1 if uri.path =~ /\/folders\/(.+?)\b/
      nil
    end
end
