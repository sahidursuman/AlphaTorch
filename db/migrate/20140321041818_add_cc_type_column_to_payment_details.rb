class AddCcTypeColumnToPaymentDetails < ActiveRecord::Migration
  def change
    add_column :payment_details, :cc_type, :string
  end
end
