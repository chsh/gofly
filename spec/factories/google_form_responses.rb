FactoryBot.define do
  factory :google_form_response do
    google_sheet { nil }
    index { 1 }
    response { "" }
    digest { "MyString" }
  end
end
