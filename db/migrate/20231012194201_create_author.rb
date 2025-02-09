class CreateAuthor < ActiveRecord::Migration[7.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.text :synopsis
      t.date :release_date
      t.integer :edition
      t.integer :price

      t.timestamps
    end
  end
end
