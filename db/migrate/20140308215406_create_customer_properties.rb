class CreateCustomerProperties < ActiveRecord::Migration
  def change
    create_table :customer_properties do |t|
      t.references :customer, index: true
      t.references :property, index: true
      t.boolean :owner

      t.timestamps
    end
  end
end
