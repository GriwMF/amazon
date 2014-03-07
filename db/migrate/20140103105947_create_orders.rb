class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.decimal :total_price, precision: 8, scale: 2
      t.string :state
      t.datetime :completed_at
      t.integer :bill_addr_id
      t.integer :ship_addr_id
      t.references :customer, index: true

      t.timestamps
    end
  end
end
