class DmRoom < ApplicationRecord
  has_many :dm_messages, dependent: :destroy
  has_many :dm_entry, class_name: "DmEntrie",foreign_key: "dm_room_id", dependent: :destroy
end
