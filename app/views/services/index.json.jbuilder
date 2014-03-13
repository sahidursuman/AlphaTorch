json.array!(@services) do |service|
  json.extract! service, :id, :name, :base_cost
  json.url service_url(service, format: :json)
end
