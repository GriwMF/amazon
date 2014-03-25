class ChangeDefaultValueOfApproved < ActiveRecord::Migration
  def up
    change_column_default :ratings, :approved, 'false'
  end
  
  def down
    change_column_default :ratings, :approved, 'f'
  end
end
