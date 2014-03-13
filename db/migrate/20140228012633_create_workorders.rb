class CreateWorkorders < ActiveRecord::Migration
  def change
    create_table :workorders do |t|
      t.string :name
      t.date :start_date
      t.integer :status_code, default: 1011

      t.timestamps
    end
  end
end
