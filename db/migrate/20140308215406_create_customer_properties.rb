class CreateCustomerProperties < ActiveRecord::Migration
  def change
    create_table :customer_properties do |t|
      t.references :customer, index: true
      t.references :property, index: true
      t.boolean :owner
      t.integer :status_code, default: 1011

      t.timestamps
    end
  end
end
