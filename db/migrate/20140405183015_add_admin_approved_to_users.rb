class AddAdminApprovedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin_confirmed, :boolean, default: false
  end
end
