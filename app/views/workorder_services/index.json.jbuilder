json.array!(@workorder_services) do |workorder_service|
  json.extract! workorder_service, :id, :service_id, :workorder_id, :schedule, :cost
  json.url workorder_service_url(workorder_service, format: :json)
end
