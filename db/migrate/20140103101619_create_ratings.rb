class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :rating, limit: 1, index: true
      t.string :text
      t.references :book, index: true
      t.references :customer, index: true

      t.timestamps
    end
  end
end
