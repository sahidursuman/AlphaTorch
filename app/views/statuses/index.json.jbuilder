json.array!(@statuses) do |status|
  json.extract! status, :id, :status_code, :status
  json.url status_url(status, format: :json)
end
