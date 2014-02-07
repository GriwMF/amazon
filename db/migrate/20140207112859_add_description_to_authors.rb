class AddDescriptionToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :desctiption, :text
  end
end
