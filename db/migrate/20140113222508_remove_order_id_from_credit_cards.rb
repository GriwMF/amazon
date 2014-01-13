class RemoveOrderIdFromCreditCards < ActiveRecord::Migration
  def change
    remove_column :credit_cards, :order_id, :integer
  end
end
