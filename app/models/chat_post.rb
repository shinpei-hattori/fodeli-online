class ChatPost < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  has_many :notifications, dependent: :destroy
  validates :user_id, presence: true
  validates :chat_room_id, presence: true
  validates :message, presence: true, length: { maximum: 140 }

  def post_datetime
    weeks = ["日", "月", "火", "水", "木", "金", "土"]
    post_date = updated_at.strftime("%Y/%m/%d")
    post_week = weeks[updated_at.wday]

    if post_date == Time.current.strftime("%Y/%m/%d")
      "今日"
    elsif post_date == (Time.current - 1.days).strftime("%Y/%m/%d")
      "昨日"
    else
      post_date + "(#{post_week})"
    end
  end

  def create_notification_chat_post!(current_user)
    temp_ids = ChatUser.where(chat_room_id: chat_room_id).where.not(user_id: current_user.id)
    unless temp_ids.nil?
      temp_ids.each do |temp_id|
        save_notification_chat_post!(current_user, self, temp_id['user_id'])
      end
    end
  end

  def save_notification_chat_post!(current_user, chat_post, visited_id)
    notification = current_user.active_notifications.new(
      chat_post_id: chat_post.id,
      visited_id: visited_id,
      action: 'chat_post'
    )
    notification.save if notification.valid?
  end
end
