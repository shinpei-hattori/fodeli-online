class Company < ApplicationRecord
  has_many :chat_rooms
  validates :name, presence: true, uniqueness: true
end
