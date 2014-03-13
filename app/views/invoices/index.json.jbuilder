json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :invoice_status_id, :invoice_date, :due_date, :invoice_amount, :balance_due
  json.url invoice_url(invoice, format: :json)
end
