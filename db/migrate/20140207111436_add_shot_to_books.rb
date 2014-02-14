class AddShotToBooks < ActiveRecord::Migration
  def change
    add_column :books, :shot, :string
  end
end
