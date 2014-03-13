class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :status_code, default: 1000
      t.date :invoice_date
      t.date :due_date
      t.integer :invoice_amount, default: 0
      #t.integer :balance_due, default: 0

      t.timestamps
    end
  end
end
