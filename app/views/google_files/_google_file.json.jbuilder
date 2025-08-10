json.extract! google_file, :id, :course_id, :url, :name, :description, :attrs, :created_at, :updated_at
json.url google_file_url(google_file, format: :json)
