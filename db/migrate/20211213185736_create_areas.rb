class CreateAreas < ActiveRecord::Migration[5.2]
  def change
    create_table :areas do |t|
      t.string :city
      t.integer :prefecture_id
      t.timestamps
    end
  end
end
