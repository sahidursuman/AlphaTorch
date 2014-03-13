class CreateCustomerAddresses < ActiveRecord::Migration
  def change
    create_table :customer_addresses do |t|
      t.string :street_address_1
      t.string :street_address_2
      t.string :city
      t.references :state, index: true
      t.string :postal_code
      t.references :customer, index: true
      t.string :description

      t.timestamps
    end
  end
end
