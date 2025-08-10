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
  end
end
