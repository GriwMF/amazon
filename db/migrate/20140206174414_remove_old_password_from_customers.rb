class RemoveOldPasswordFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :password
  end
end
