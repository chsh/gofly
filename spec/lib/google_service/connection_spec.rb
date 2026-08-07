require 'rails_helper'

RSpec.describe GoogleService::Connection, type: :model do
  it 'can generate lot code' do
    conn = GoogleService::Connection.new

    uri1 = URI.parse("https://drive.google.com/file/d/1key/view?usp=drive_link")
    expect(conn.send(:file_id_from_uri, uri1)).to eq "1key"

    # host should be `drive.google.com`
    uri2 = URI.parse("https://drive.no-google.com/file/d/1key/view?usp=drive_link")
    expect(conn.send(:file_id_from_uri, uri2)).to be_nil

    # protocol should be `https`
    uri3 = URI.parse("http://drive.google.com/file/d/1key/view?usp=drive_link")
    expect(conn.send(:file_id_from_uri, uri3)).to be_nil

    # can get folder_id
    uri4 = URI.parse("https://drive.google.com/drive/folders/1Key?usp=drive_link")
    expect(conn.send(:file_id_from_uri, uri4)).to eq "1Key"

    # can get spreadsheet(file) id
    uri5 = URI.parse("https://drive.google.com/spreadsheet?d=1Key&usp=drive_link")
    expect(conn.send(:file_id_from_uri, uri5)).to eq "1Key"

    # real example 1
    uri6 = URI.parse("https://drive.google.com/drive/folders/1a-_rMEHg9nU6IoCA2s9Iqsc8_E2qgqsSQBJMz-Ajylrk?usp=drive_link")
    expect(conn.send(:file_id_from_uri, uri6)).to eq "1a-_rMEHg9nU6IoCA2s9Iqsc8_E2qgqsSQBJMz-Ajylrk"

    uri7 = URI.parse("https://drive.google.com/open?id=14D4o-YW69Oufim")
    expect(conn.send(:file_id_from_uri, uri7)).to eq "14D4o-YW69Oufim"

    # real example 2: id ends with a hyphen (must not be truncated)
    uri8 = URI.parse("https://drive.google.com/open?id=1w4n-IQyI0wuS6fZggGp4TjhcQAskKvR-")
    expect(conn.send(:file_id_from_uri, uri8)).to eq "1w4n-IQyI0wuS6fZggGp4TjhcQAskKvR-"

    # id ends with a hyphen, followed by another query param
    uri9 = URI.parse("https://drive.google.com/open?id=1w4n-IQyI0wuS6fZggGp4TjhcQAskKvR-&usp=drive_link")
    expect(conn.send(:file_id_from_uri, uri9)).to eq "1w4n-IQyI0wuS6fZggGp4TjhcQAskKvR-"

    # folder id ends with a hyphen
    uri10 = URI.parse("https://drive.google.com/drive/folders/1AbcDef-?usp=drive_link")
    expect(conn.send(:file_id_from_uri, uri10)).to eq "1AbcDef-"

    # file id ends with a hyphen (/d/ pattern)
    uri11 = URI.parse("https://drive.google.com/file/d/1AbcDef-/view?usp=drive_link")
    expect(conn.send(:file_id_from_uri, uri11)).to eq "1AbcDef-"

    # /d/ pattern without trailing slash
    uri12 = URI.parse("https://drive.google.com/file/d/1AbcDef-")
    expect(conn.send(:file_id_from_uri, uri12)).to eq "1AbcDef-"

    # nil returns nil
    expect(conn.send(:file_id_from_uri, nil)).to be_nil

    # blank returns nil
    expect(conn.send(:file_id_from_uri, "")).to be_nil

    # no url returns nil
    expect(conn.send(:file_id_from_uri, "(12345)")).to be_nil
  end

  describe '#create_spreadsheet_from_csv' do
    let(:conn) { GoogleService::Connection.new }
    let(:drive) { instance_double(Google::Apis::DriveV3::DriveService) }
    let(:meta) do
      Google::Apis::DriveV3::File.new(
        id: "1createdKey",
        mime_type: "application/vnd.google-apps.spreadsheet",
        name: "test-sheet")
    end

    before { allow(conn).to receive(:drive).and_return(drive) }

    it 'uploads csv content converted to a spreadsheet in the folder' do
      Tempfile.create(%w[students .csv]) do |f|
        f.write("No,学籍番号,氏名\n1,2400000000,山田 太郎\n")
        f.flush

        expect(drive).to receive(:create_file) do |file_metadata, **params|
          expect(file_metadata.name).to eq "test-sheet"
          expect(file_metadata.mime_type).to eq "application/vnd.google-apps.spreadsheet"
          expect(file_metadata.parents).to eq [ "1folderKey" ]
          expect(params[:upload_source]).to eq f.path
          expect(params[:content_type]).to eq "text/csv"
          expect(params[:supports_all_drives]).to be true
          meta
        end

        object = conn.create_spreadsheet_from_csv(folder_id: "1folderKey", name: "test-sheet", csv_path: f.path)
        expect(object).to be_a GoogleService::Sheet
        expect(object.id).to eq "1createdKey"
      end
    end

    it 'creates an empty spreadsheet for a zero-byte csv' do
      Tempfile.create(%w[empty .csv]) do |f|
        expect(drive).to receive(:create_file) do |file_metadata, **params|
          expect(file_metadata.parents).to eq [ "1folderKey" ]
          expect(params).not_to have_key(:upload_source)
          expect(params).not_to have_key(:content_type)
          meta
        end

        object = conn.create_spreadsheet_from_csv(folder_id: "1folderKey", name: "test-sheet", csv_path: f.path)
        expect(object).to be_a GoogleService::Sheet
      end
    end
  end
end
