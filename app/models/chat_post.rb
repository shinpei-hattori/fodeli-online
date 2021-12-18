class ChatPost < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  validates :user_id, presence: true
  validates :chat_room_id, presence: true
  validates :message, presence: true, length: { maximum: 140 }
end
