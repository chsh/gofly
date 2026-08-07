require 'rails_helper'

RSpec.describe GoogleService::Sheet, type: :model do
  describe '#write_csv' do
    let(:sheets) { instance_double(Google::Apis::SheetsV4::SheetsService) }
    let(:connection) { instance_double(GoogleService::Connection, sheets: sheets) }
    let(:meta) do
      Google::Apis::DriveV3::File.new(
        id: "1sheetKey",
        mime_type: "application/vnd.google-apps.spreadsheet",
        name: "2026-ss-pg1-1-S55820201A")
    end
    let(:sheet) { GoogleService::Sheet.new(connection, meta) }

    def stub_sheet_titles(*titles)
      spreadsheet = Google::Apis::SheetsV4::Spreadsheet.new(
        sheets: titles.map { |title|
          Google::Apis::SheetsV4::Sheet.new(
            properties: Google::Apis::SheetsV4::SheetProperties.new(title: title))
        })
      allow(sheets).to receive(:get_spreadsheet).and_return(spreadsheet)
    end

    it 'clears the first sheet and writes csv rows into it by default' do
      stub_sheet_titles("シート1")

      Tempfile.create(%w[students .csv]) do |f|
        f.write("No,学籍番号,氏名\n1,2400000000,山田 太郎\n")
        f.flush

        expect(sheets).to receive(:clear_values).with("1sheetKey", "'シート1'", anything)
        expect(sheets).to receive(:update_spreadsheet_value) do |id, range, value_range, **params|
          expect(id).to eq "1sheetKey"
          expect(range).to eq "'シート1'!A1"
          expect(value_range.values).to eq [
            %w[No 学籍番号 氏名],
            [ "1", "2400000000", "山田 太郎" ]
          ]
          expect(params[:value_input_option]).to eq "RAW"
        end

        sheet.write_csv(f.path)
      end
    end

    it 'adds the sheet when the given title does not exist' do
      stub_sheet_titles("シート1")

      Tempfile.create(%w[students .csv]) do |f|
        f.write("No\n1\n")
        f.flush

        expect(sheets).to receive(:batch_update_spreadsheet) do |id, request|
          expect(id).to eq "1sheetKey"
          expect(request.requests.first[:add_sheet][:properties][:title]).to eq "pg1-1"
        end
        expect(sheets).to receive(:clear_values).with("1sheetKey", "'pg1-1'", anything)
        expect(sheets).to receive(:update_spreadsheet_value)

        sheet.write_csv(f.path, sheet_title: "pg1-1")
      end
    end

    it 'only clears the sheet for a zero-byte csv' do
      stub_sheet_titles("シート1")

      Tempfile.create(%w[empty .csv]) do |f|
        expect(sheets).to receive(:clear_values).with("1sheetKey", "'シート1'", anything)
        expect(sheets).not_to receive(:update_spreadsheet_value)

        sheet.write_csv(f.path)
      end
    end
  end
end
