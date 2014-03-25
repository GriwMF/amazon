class AddFullDescriptionToBooks < ActiveRecord::Migration
  def change
    add_column :books, :full_desctiption, :text
  end
end
