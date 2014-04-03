class AddMapDataToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :map_data, :text
  end
end
