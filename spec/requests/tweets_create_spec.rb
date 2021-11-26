require 'rails_helper'

RSpec.describe "ツイートの投稿", type: :request do
  let(:user) { create(:user) }

  before do
    login_for_request(user)
    get root_url
  end

  it "有効なツイートで登録できること" do
    expect {
      post tweets_path, params: { tweet: { content: "今日は８時間稼働しました！" } }
    } .to change(Tweet, :count).by(1)
    follow_redirect!
    expect(response).to render_template('static_pages/home')
  end

  it "無効なツイートでは登録できるないこと" do
    expect {
      post tweets_path, params: { tweet: { content: "" } }
    } .not_to change(Tweet, :count)
    follow_redirect!
    expect(response).to render_template('static_pages/home')
  end
end
