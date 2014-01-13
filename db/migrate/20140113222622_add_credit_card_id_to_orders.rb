class AddCreditCardIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :credit_card_id, :integer
    add_index :orders, :credit_card_id
  end
end
