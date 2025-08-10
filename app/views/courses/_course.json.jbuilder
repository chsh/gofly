json.extract! course, :id, :name, :year, :season, :description, :attrs, :created_at, :updated_at
json.url course_url(course, format: :json)
