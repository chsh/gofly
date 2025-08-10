json.extract! google_form_response, :id, :google_sheet_id, :index, :response, :digest, :created_at, :updated_at
json.url google_form_response_url(google_form_response, format: :json)
