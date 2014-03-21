class AddNameColumnsToPaymentDetails < ActiveRecord::Migration
  def change
    add_column :payment_details, :cc_name, :string
    add_column :payment_details, :cash_name, :string
  end
end
