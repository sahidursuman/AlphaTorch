class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.integer :base_cost

      t.timestamps
    end
  end
end
