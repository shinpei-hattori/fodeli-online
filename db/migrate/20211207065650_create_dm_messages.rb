class CreateDmMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :dm_messages do |t|
      t.references :user, foreign_key: true
      t.references :dm_room, foreign_key: true
      t.text :message

      t.timestamps
    end
  end
end
