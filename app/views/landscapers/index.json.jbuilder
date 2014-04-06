json.array!(@landscapers) do |landscaper|
  json.extract! landscaper, :id, :status_id, :status_code, :first_name, :last_name, :middle_initial, :primary_phone, :secondary_phone, :email, :description, :rating
  json.url landscaper_url(landscaper, format: :json)
end