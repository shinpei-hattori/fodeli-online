class ChatPost < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  validates :user_id, presence: true
  validates :chat_room_id, presence: true
  validates :message, presence: true, length: { maximum: 140 }

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
end
