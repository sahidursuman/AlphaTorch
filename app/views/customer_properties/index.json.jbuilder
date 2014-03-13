json.array!(@customer_properties) do |customer_property|
  json.extract! customer_property, :id, :customer_id, :property_id, :owner
  json.url customer_property_url(customer_property, format: :json)
end
