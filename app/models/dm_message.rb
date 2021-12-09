class DmMessage < ApplicationRecord
  validates :user_id, presence: true
  validates :dm_room_id, presence: true
  validates :message, presence: true, length: { maximum: 50 }
  belongs_to :user
  belongs_to :dm_room
end
