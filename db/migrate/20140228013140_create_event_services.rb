class CreateEventServices < ActiveRecord::Migration
  def change
    create_table :event_services do |t|
      t.references :service, index: true
      t.references :event, index: true
      t.references :workorder_service, index: true
      t.integer :cost

      t.timestamps
    end

    add_index :event_services, :workorder_service_id
  end
end
