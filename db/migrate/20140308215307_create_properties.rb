class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :street_address_1
      t.string :street_address_2
      t.string :city
      t.references :state, index: true
      t.string :postal_code

      t.timestamps
    end
  end
end
