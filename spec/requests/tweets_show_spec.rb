require 'rails_helper'

RSpec.describe "ツイート個別ページ", type: :request do
  let!(:user) { create(:user) }
  let!(:tweet) { create(:tweet, user: user) }

  context "認可されたユーザーの場合" do
    it "レスポンスが正常に表示されること" do
      login_for_request(user)
      get tweet_path(tweet)
      expect(response).to have_http_status "200"
      expect(response).to render_template('tweets/show')
    end
  end

  context "ログインしていないユーザーの場合" do
    it "ログイン画面にリダイレクトすること" do
      get tweet_path(tweet)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
