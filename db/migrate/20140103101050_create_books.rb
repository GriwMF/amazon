class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title, index: true
      t.string :descirption
      t.references :author, index: true
      t.references :category, index: true
      t.decimal :price, precision: 8, scale: 2
      t.integer :in_stock

      t.timestamps
    end
  end
end
