class CreateEventServices < ActiveRecord::Migration
  def change
    create_table :event_services do |t|
      t.references :service, index: true
      t.references :event, index: true
      t.integer :cost

      t.timestamps
    end
  end
end
