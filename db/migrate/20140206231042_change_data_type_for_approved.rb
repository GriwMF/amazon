class ChangeDataTypeForApproved < ActiveRecord::Migration
  def up
    change_column :ratings, :approved, :string
  end
  def down
    change_column :ratings, :approved, :boolean
  end
end
