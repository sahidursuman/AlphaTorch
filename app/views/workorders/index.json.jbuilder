json.array!(@workorders) do |workorder|
  json.extract! workorder, :id, :start_date, :billing_cycle
  json.url workorder_url(workorder, format: :json)
end
