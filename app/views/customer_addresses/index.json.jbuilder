json.array!(@customer_addresses) do |customer_address|
  json.extract! customer_address, :id, :street_address_1, :street_address_2, :city, :state_id, :postal_code, :customer_id, :description
  json.url customer_address_url(customer_address, format: :json)
end
