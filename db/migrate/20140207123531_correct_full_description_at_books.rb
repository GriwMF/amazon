class CorrectFullDescriptionAtBooks < ActiveRecord::Migration
  def change
    remove_column :books, :full_desctiption
    add_column :books, :full_description, :text
  end
end
