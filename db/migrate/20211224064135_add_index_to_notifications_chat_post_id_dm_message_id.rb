class AddIndexToNotificationsChatPostIdDmMessageId < ActiveRecord::Migration[5.2]
  def change
    add_index :notifications, :dm_message_id
    add_index :notifications, :chat_post_id
  end
end
