class DmMessage < ApplicationRecord
  validates :user_id, presence: true
  validates :dm_room_id, presence: true
  validates :message, presence: true, length: { maximum: 50 }
  belongs_to :user
  belongs_to :dm_room, touch: true
  has_many :notifications, dependent: :destroy

  def post_datetime
    weeks = ["日","月","火","水","木","金","土"]
    post_date = self.updated_at.strftime("%Y/%m/%d")
    post_week = weeks[self.updated_at.wday]

    if post_date == Time.current.strftime("%Y/%m/%d")
      return "今日"
    elsif post_date == (Time.current - 1.days).strftime("%Y/%m/%d")
      return "昨日"
    else
      return post_date + "(#{post_week})"
    end
  end

  def create_notification_dm_message!(current_user)
    temp_ids = DmEntrie.where(dm_room_id: self.dm_room_id).where.not(user_id: current_user.id)
    unless temp_ids.nil?
      temp_ids.each do |temp_id|
        save_notification_dm_message!(current_user, self, temp_id['user_id'])
      end
    end
  end

  def save_notification_dm_message!(current_user, dm_message, visited_id)
    notification = current_user.active_notifications.new(
      dm_message_id: dm_message.id,
      visited_id: visited_id,
      action: 'dm_message'
    )
    notification.save if notification.valid?
  end

end
