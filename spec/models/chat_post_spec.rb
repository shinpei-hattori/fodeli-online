require 'rails_helper'

RSpec.describe ChatPost, type: :model do
  let!(:chat_post) { create(:chat_post) }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(chat_post).to be_valid
    end

    it "ユーザーIDがなければ無効な状態であること" do
      post = build(:chat_post, user_id: nil)
      post.valid?
      expect(post.errors[:user_id]).to include("を入力してください")
    end

    it "ルームIDがなければ無効な状態であること" do
      post = build(:chat_post, chat_room_id: nil)
      post.valid?
      expect(post.errors[:chat_room_id]).to include("を入力してください")
    end

    it "メッセージがなければ無効な状態であること" do
      post = build(:chat_post, message: nil)
      post.valid?
      expect(post.errors[:message]).to include("を入力してください")
    end

    it "メッセージが140文字以内であること" do
      post = build(:chat_post, message: "あ" * 141)
      post.valid?
      expect(post.errors[:message]).to include("は140文字以内で入力してください")
    end
  end
end
