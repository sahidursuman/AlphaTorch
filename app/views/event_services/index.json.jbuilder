json.array!(@event_services) do |event_service|
  json.extract! event_service, :id, :service_id, :event_id, :cost
  json.url event_service_url(event_service, format: :json)
end
