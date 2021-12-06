class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  mount_uploaders :pictures, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  # ツイートに付属するコメントのフィードを作成
  def feed_comment(tweet_id)
    Comment.where("tweet_id = ?", tweet_id)
  end

  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      pictures.each do |picture|
        if picture.size > 5.megabytes
          errors.add(:pictures, "は5MB未満で投稿してください")
        end
      end
    end
end
