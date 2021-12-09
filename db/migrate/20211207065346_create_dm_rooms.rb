class CreateDmRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :dm_rooms do |t|

      t.timestamps
    end
  end
end
