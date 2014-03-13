json.array!(@properties) do |property|
  json.extract! property, :id, :street_address_1, :street_address_2, :city, :state_id, :postal_code
  json.url property_url(property, format: :json)
end
