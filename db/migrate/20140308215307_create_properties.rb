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

    add_index :properties, [:street_address_1, :street_address_2, :city, :state_id], unique: true, name: 'unique_address'
  end
end
