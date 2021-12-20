class Comment < ApplicationRecord
  belongs_to :tweet
  belongs_to :user
  has_many :notifications, dependent: :destroy
  validates :user_id, presence: true
  validates :tweet_id, presence: true
  validates :content, presence: true, length: { maximum: 50 }
end
