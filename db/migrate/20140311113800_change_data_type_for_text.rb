class ChangeDataTypeForText < ActiveRecord::Migration
  def change
    change_column :ratings, :text, :text
  end
end
