class CreateChatRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_rooms do |t|
      t.references :company, foreign_key: true
      t.references :area, foreign_key: true
      t.timestamps
    end
    add_index :chat_rooms, [:company_id, :area_id], unique: true
  end
end
