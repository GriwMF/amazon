class MoveAddressesToCustomer < ActiveRecord::Migration
  def change
    remove_column :addresses, :customer_id
    remove_column :orders, :bill_addr_id
    remove_column :orders, :ship_addr_id

    add_column :customers, :bill_addr_id, :integer
    add_column :customers, :ship_addr_id, :integer
  end
end
