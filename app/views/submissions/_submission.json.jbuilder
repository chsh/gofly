json.extract! submission, :id, :student_id, :type, :attrs, :created_at, :updated_at
json.url submission_url(submission, format: :json)
