class AddIndexToCustomers < ActiveRecord::Migration
  def change
    add_index :customers, :email, unique: true
  end
end
