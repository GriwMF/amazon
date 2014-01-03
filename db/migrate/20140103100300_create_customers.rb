class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :email, index: true
      t.string :password
      t.string :firstname
      t.string :lastname

      t.timestamps
    end
    add_index :customers, [:firstname, :lastname]
  end
end
