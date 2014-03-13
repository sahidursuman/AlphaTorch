class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :status_code, default: 1011
      t.string :first_name
      t.string :middle_initial
      t.string :last_name
      t.string :primary_phone
      t.string :secondary_phone
      t.string :email
      t.string :description

      t.timestamps
    end
  end
end
