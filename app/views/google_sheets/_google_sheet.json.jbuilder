json.extract! google_sheet, :id, :course_id, :url, :name, :description, :attrs, :created_at, :updated_at
json.url google_sheet_url(google_sheet, format: :json)
