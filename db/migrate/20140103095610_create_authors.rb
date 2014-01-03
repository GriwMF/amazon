class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :firstname
      t.string :lastname

      t.timestamps
    end
    add_index :authors, [:firstname, :lastname]
  end
end
