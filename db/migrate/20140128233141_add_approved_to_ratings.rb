class AddApprovedToRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :approved, :boolean, default: nil
  end
end
