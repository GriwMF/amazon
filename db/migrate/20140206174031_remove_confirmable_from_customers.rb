class RemoveConfirmableFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :confirmation_token
    remove_column :customers, :confirmed_at
    remove_column :customers, :confirmation_sent_at
    remove_column :customers, :unconfirmed_email
  end
end
