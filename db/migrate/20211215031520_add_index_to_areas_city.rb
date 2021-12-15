class AddIndexToAreasCity < ActiveRecord::Migration[5.2]
  def change
    add_index :areas, :city, unique: true
  end
end
