class AddDefaultValueToApproved < ActiveRecord::Migration
  def up
    change_column_default :ratings, :approved, false
  end
  
  def down
    change_column_default :ratings, :approved, nil
  end
end
