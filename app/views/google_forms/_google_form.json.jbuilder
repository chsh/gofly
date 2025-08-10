json.extract! google_form, :id, :course_id, :url, :name, :description, :attrs, :created_at, :updated_at
json.url google_form_url(google_form, format: :json)
