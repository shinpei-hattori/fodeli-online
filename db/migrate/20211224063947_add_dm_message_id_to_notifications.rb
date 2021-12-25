class AddDmMessageIdToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :dm_message_id, :integer
  end
end
