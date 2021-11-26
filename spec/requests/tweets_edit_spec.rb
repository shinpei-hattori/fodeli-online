require 'rails_helper'

RSpec.describe "ツイート編集", type: :request do
  let!(:user) { create(:user) }
  let!(:tweet) { create(:tweet, user: user) }
  let!(:other_user) { create(:user) }

  context "認可されたユーザーの場合" do
    it "レスポンスが正常に表示されること、値が更新されていること(+フレンドリーフォワーディング)" do
      get edit_tweet_path(tweet)
      login_for_request(user)
      follow_redirect!
      expect(response).to render_template('tweets/edit')
      patch tweet_path(tweet), params: { tweet: { content: "今夜は焼肉かなぁ" } }
      expect(tweet.reload.content).to eq("今夜は焼肉かなぁ")
      follow_redirect!
      expect(response).to render_template('tweets/show')
    end
  end

  context "ログインしていないユーザーの場合" do
    it "ログイン画面にリダイレクトすること" do
      # 編集
      get edit_tweet_path(tweet)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
      # 更新
      patch tweet_path(tweet), params: { tweet: { content: "今夜は焼肉かなぁ" } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end

  context "別アカウントのユーザーの場合" do
    it "ホーム画面にリダイレクトすること" do
      # 編集
      login_for_request(other_user)
      get edit_tweet_path(tweet)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
      # 更新
      patch tweet_path(tweet), params: { tweet: { content: "今夜は焼肉かなぁ" } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end
end
