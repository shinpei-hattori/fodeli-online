class User < ApplicationRecord
  has_many :tweets, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  attr_accessor :remember_token
  before_save :downcase_email
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :introduction, length: { maximum: 255 }

  class << self # クラスメソッド 使用例 User.digest("aaa")
    # 渡された文字列のハッシュ値を返す
    def digest(string)
      if ActiveModel::SecurePassword.min_cost
        cost = BCrypt::Engine::MIN_COST
      else
        cost = BCrypt::Engine.cost
      end
      BCrypt::Password.create(string, cost: cost)
    end

    # ランダムなトークンを返す
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # フィード一覧を取得
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Tweet.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    # 新しくトークンを作成。
    self.remember_token = User.new_token
    # DB上のremember_digestカラムにトークンをハッシュ化した値を保存。
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  # 現在のユーザーがフォローされていたらtrueを返す
  def followed_by?(other_user)
    followers.include?(other_user)
  end

  # ツイートにいいね登録する
  def like(tweet)
    Like.create!(user_id: id, tweet_id: tweet.id)
  end

  # ツイートのいいねを解除する
  def unlike(tweet)
    Like.find_by(user_id: id, tweet_id: tweet.id).destroy
  end

  # 現在のユーザーがいいね登録してたらtrueを返す
  def like?(tweet)
    !Like.find_by(user_id: id, tweet_id: tweet.id).nil?
  end

  private

    def downcase_email
      self.email = email.downcase
    end
end
