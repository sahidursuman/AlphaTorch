class CreatePaymentDetails < ActiveRecord::Migration
  def change
    create_table :payment_details do |t|
      t.date :payment_date
      t.string :cc_processing_code
      t.string :check_name
      t.integer :check_number
      t.string :check_routing
      t.integer :cash_subtotal
      t.integer :check_subtotal
      t.integer :cc_subtotal
      t.references :invoice, index: true

      t.timestamps
    end
  end
end
