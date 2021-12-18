class CreateChatPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_posts do |t|
      t.references :user, foreign_key: true
      t.references :chat_room, foreign_key: true
      t.text :message
      t.timestamps
    end
    add_index :chat_posts,[:user_id,:chat_room_id]
  end
end
