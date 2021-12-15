class DmRoom < ApplicationRecord
  has_many :dm_messages, dependent: :destroy
  has_many :dm_entry, class_name: "DmEntrie", dependent: :destroy
  default_scope -> { order(created_at: :desc) }
end
