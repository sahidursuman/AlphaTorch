json.array!(@events) do |event|
  json.extract! event, :id, :workorder_id, :start, :end, :all_day, :description, :cost
  json.url event_url(event, format: :json)
end
