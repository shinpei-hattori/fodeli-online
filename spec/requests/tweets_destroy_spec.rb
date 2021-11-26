require 'rails_helper'

RSpec.describe "ツイートの削除", type: :request do
  let!(:user) {create(:user)}
  let!(:other_user) {create(:user)}
  let!(:tweet) {create(:tweet,user: user)}


  it "本人であればツイートを削除できること" do
    login_for_request(user)
    get root_path
    expect {
      delete tweet_path(tweet)
    }.to change(Tweet,:count).by(-1)
    follow_redirect!
    expect(response).to render_template('static_pages/home')
  end

  it "本人でなければツイートは削除できない" do
    login_for_request(other_user)
    get root_path
    expect {
      delete tweet_path(tweet)
    }.not_to change(Tweet,:count)
    expect(response).to have_http_status "302"
    follow_redirect!
    expect(response).to render_template('static_pages/home')
  end

  it "ログインしていなければログイン画面へリダイレクトすること" do
    expect {
      delete tweet_path(tweet)
    }.not_to change(Tweet, :count)
    expect(response).to have_http_status "302"
    expect(response).to redirect_to login_path
  end


end
