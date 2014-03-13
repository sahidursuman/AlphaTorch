json.array!(@customers) do |customer|
  json.extract! customer, :id, :status_id, :first_name, :last_name, :primary_phone, :secondary_phone, :email, :description
  json.url customer_url(customer, format: :json)
end
