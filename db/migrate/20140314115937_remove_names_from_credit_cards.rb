class RemoveNamesFromCreditCards < ActiveRecord::Migration
  def change
    remove_column :credit_cards, :firstname, :string
    remove_column :credit_cards, :lastname, :string
  end
end
