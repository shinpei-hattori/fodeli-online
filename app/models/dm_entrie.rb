class DmEntrie < ApplicationRecord
  validates :user_id, presence: true
  validates :dm_room_id, presence: true
  belongs_to :user
  belongs_to :dm_room
end
