class ChangeCoutryIdForAddresses < ActiveRecord::Migration
  def change
    remove_column :addresses, :country_id
    add_column :addresses, :country, :string
    add_index :addresses, :country
  end
end
