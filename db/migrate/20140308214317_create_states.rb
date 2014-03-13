class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.references :country, index: true
      t.string :name
      t.string :short_name

      t.timestamps
    end
  end
end
