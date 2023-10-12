class ChangeAuthorsToBooks < ActiveRecord::Migration[7.0]
  def change
    rename_table :authors, :books
  end
end
