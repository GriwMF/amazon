class CorrectDescriptionAtAuthors < ActiveRecord::Migration
  def change
    remove_column :authors, :desctiption
    add_column :authors, :description, :text
  end
end
