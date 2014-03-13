class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :workorder, index: true
      t.boolean :all_day
      t.datetime :start
      t.datetime :end
      t.string :name
      t.references :invoice, index: true
      t.integer :status_code, default: 1007

      t.timestamps
    end
  end
end