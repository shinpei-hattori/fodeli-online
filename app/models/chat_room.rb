class ChatRoom < ApplicationRecord
  belongs_to :company
  belongs_to :area
  has_many :chat_users
  has_many :chat_posts, dependent: :destroy
  validates :company_id, presence: true
  validates :area_id, presence: true
end
