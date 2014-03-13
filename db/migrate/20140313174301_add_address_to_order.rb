class AddAddressToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :bill_addr_id, :integer
    add_column :orders, :ship_addr_id, :integer
  end
end
