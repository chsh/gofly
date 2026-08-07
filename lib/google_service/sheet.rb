# frozen_string_literal: true

require "csv"

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

  def sheet_titles
    spreadsheet = service.sheets.get_spreadsheet(id, fields: "sheets(properties(sheetId,title))")
    spreadsheet.sheets.map { |sheet| sheet.properties.title }
  end

  # CSVファイルの内容をシート(タブ)に書き込む。sheet_title省略時は先頭シート。
  # 指定シートがなければ追加し、あれば既存の値をクリアして上書きする。
  # 0バイトのCSVは空シートの作成/クリアのみ行う。
  def write_csv(csv_path, sheet_title: nil)
    rows = CSV.read(csv_path)
    titles = sheet_titles
    sheet_title ||= titles.first
    add_sheet(sheet_title) unless titles.include?(sheet_title)
    clear_sheet(sheet_title)
    return if rows.empty?
    value_range = Google::Apis::SheetsV4::ValueRange.new(values: rows)
    service.sheets.update_spreadsheet_value(
      id, "'#{sheet_title}'!A1", value_range, value_input_option: "RAW")
  end

  private
    def add_sheet(title)
      request = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new(
        requests: [ { add_sheet: { properties: { title: title } } } ])
      service.sheets.batch_update_spreadsheet(id, request)
    end

    def clear_sheet(title)
      service.sheets.clear_values(
        id, "'#{title}'", Google::Apis::SheetsV4::ClearValuesRequest.new)
    end
end
