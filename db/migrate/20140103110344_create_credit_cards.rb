class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.string :number
      t.integer :cvv
      t.integer :expiration_month
      t.integer :expiration_year
      t.string :firstname
      t.string :lastname
      t.references :customer, index: true
      t.references :order, index: true

      t.timestamps
    end
  end
end
