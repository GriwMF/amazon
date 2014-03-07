class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.decimal :price, precision: 8, scale: 2
      t.integer :quantity
      t.references :book, index: true
      t.references :order, index: true

      t.timestamps
    end
  end
end
