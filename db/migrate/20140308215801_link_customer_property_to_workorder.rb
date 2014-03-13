class LinkCustomerPropertyToWorkorder < ActiveRecord::Migration
  def change
    add_column :workorders, :customer_property_id, :integer
    add_index  :workorders, :customer_property_id
  end
end
