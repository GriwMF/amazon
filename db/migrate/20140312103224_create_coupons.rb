class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code
      t.integer :discount, limit: 1
    end

    add_index :coupons, :code
  end
end
