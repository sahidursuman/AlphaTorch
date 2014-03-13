json.array!(@payment_details) do |payment_detail|
  json.extract! payment_detail, :id, :payment_date, :cc_processing_code, :check_name, :check_number, :check_routing, :cash_subtotal, :check_subtotal, :cc_subtotal, :invoice_id
  json.url payment_detail_url(payment_detail, format: :json)
end
