class CorrectDescriptionAtBooks < ActiveRecord::Migration
  def change
    remove_column :books, :descirption
    add_column :books, :description, :text
  end
end
