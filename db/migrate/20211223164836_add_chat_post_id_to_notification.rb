class AddChatPostIdToNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :chat_post_id, :integer
  end
end
