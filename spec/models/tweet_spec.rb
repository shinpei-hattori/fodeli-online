require 'rails_helper'

RSpec.describe Tweet, type: :model do
  let(:tweet) { create(:tweet) }
  let(:picture_path) { File.join(Rails.root, 'spec/fixtures/files/test_image.jpg') }
  let(:picture) { [Rack::Test::UploadedFile.new(picture_path)] }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(tweet).to be_valid
    end

    it "ツイートがなければ無効な状態であること" do
      tweet = build(:tweet, content: nil)
      tweet.valid?
      expect(tweet.errors[:content]).to include("を入力してください")
    end

    it "ツイートが140文字以内であること" do
      tweet = build(:tweet, content: "あ" * 141)
      tweet.valid?
      expect(tweet.errors[:content]).to include("は140文字以内で入力してください")
    end

    it "ユーザーIDがなければ無効な状態であること" do
      tweet = build(:tweet, user_id: nil)
      tweet.valid?
      expect(tweet.errors[:user_id]).to include("を入力してください")
    end

    it "画像が保存できること" do
      tweet = build(:tweet)
      tweet.pictures[0] = picture
      expect(tweet.valid?).to be_truthy
    end
  end
end
