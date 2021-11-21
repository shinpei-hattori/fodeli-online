require 'rails_helper'

RSpec.describe "ツイートの削除", type: :request do
  let!(:user) {create(:user)}
  let!(:other_user) {create(:user)}
  let!(:tweet) {create(:tweet,user: user)}

  before do
    login_for_request(user)
  end

  it "本人であればツイートを削除できること" do
    get root_path
    expect {
      delete tweet_path(tweet)
    }.to change(Tweet,:count).by(-1)
    follow_redirect!
    expect(response).to render_template('static_pages/home')
  end

  it "本人でなければツイートは削除できるない" do
    login_for_request(other_user)
    get root_path
    expect {
      delete tweet_path(tweet)
    }.not_to change(Tweet,:count)
    follow_redirect!
    expect(response).to render_template('static_pages/home')
  end
end
