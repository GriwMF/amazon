class CorrectStateAtRatings < ActiveRecord::Migration
  def change
    remove_column :ratings, :approved
    add_column :ratings, :state, :string, index: true, default: "pending"
  end
end
