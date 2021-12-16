class CreateChatUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_users do |t|
      t.references :user, foreign_key: true
      t.references :chat_room, foreign_key: true
      t.timestamps
    end
    add_index :chat_users,[:user_id,:chat_room_id], unique: true
  end
end
