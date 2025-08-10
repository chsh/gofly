class GoogleSheet < ApplicationRecord
  belongs_to :course

  include GoogleConnectionable

  def values(range, raw: false)
    r = google_connection.sheets.get_spreadsheet_values(id, range)
    return r if raw
    r.values
  end
end
