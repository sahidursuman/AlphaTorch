class CreateWorkorderServices < ActiveRecord::Migration
  def change
    create_table :workorder_services do |t|
      t.references :service, index: true
      t.references :workorder, index: true
      t.text :schedule
      t.integer :cost

      t.timestamps
    end
  end
end
