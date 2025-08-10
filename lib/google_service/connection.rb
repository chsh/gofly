# frozen_string_literal: true

class GoogleService::Connection
  def object_from_url(uri_or_string)
    file_id = file_id_from_uri(uri_or_string)
    return nil if file_id.blank?
    get_object(file_id)
  end

  def get_object(file_id)
    begin
      meta = drive.get_file(file_id, supports_all_drives: true)
      GoogleService::ObjectSelector.from(meta)
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

  def sheets
    @sheets ||= begin
      authorizer = new_authorizer
      authorizer.fetch_access_token!
      sheets = Google::Apis::SheetsV4::SheetsService.new
      sheets.authorization = authorizer
      sheets
    end
  end

  alias_method :client, :drive

  def file_id_from_uri(uri_or_string)
    uri = uri_from(uri_or_string)
    return nil unless uri.scheme == "https"
    return nil unless uri.host.present?
    return nil unless uri.host.in?(%w( drive.google.com docs.google.com )) 
    return $1 if uri.path =~ /\/d\/([a-zA-Z\d][a-zA-Z\d\-_]+)\//
    return $1 if uri.query =~ /\bd=([a-zA-Z\d][a-zA-Z\d\-_]+)\b/
    return $1 if uri.path =~ /\/folders\/([a-zA-Z\d][a-zA-Z\d\-_]+)\b/
    nil
  end

  private
    def service_account_credential_io
      path = ENV["GOOGLE_SERVICE_ACCOUNT_CREDENTIAL_PATH"]
      raise "no GOOGLE_SERVICE_ACCOUNT_CREDENTIAL_PATH present." if path.blank?
      path = Rails.root.join(path) unless path.starts_with?("/")
      raise "path=#{path} not found." unless File.exist?(path)
      content = File.read(path)
      StringIO.new(content)
    end

    def new_authorizer
      Google::Auth::ServiceAccountCredentials.
        make_creds(
          json_key_io: service_account_credential_io,
          scope: Google::Apis::DriveV3::AUTH_DRIVE_READONLY)
    end

    def uri_from(uri_or_string)
      case uri_or_string
      when URI then uri_or_string
      when String then URI.parse(uri_or_string)
      else raise "invalid uri_or_string: class=#{uri_or_string.class} value=#{uri_or_string}"
      end
    end
end
