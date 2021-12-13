class CreateDmEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :dm_entries do |t|
      t.references :user, foreign_key: true
      t.references :dm_room, foreign_key: true

      t.timestamps
    end
  end
end
