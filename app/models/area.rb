class Area < ApplicationRecord
  belongs_to :prefecture
  has_many :chat_rooms
  validates :city, presence: true, uniqueness: true
end
