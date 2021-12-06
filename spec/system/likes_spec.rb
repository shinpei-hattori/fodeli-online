require 'rails_helper'

RSpec.describe "Likes", type: :system do
  let!(:user) { create(:user) }
  let!(:tweet) { create(:tweet, user: user) }

  context "ツイートのいいね登録/解除" do
    before do
      login_for_system(user)
    end

    it "トップページからいいね登録/解除ができること", js: true do
      visit root_path
      link = find('.like')
      expect(link[:href]).to include "/likes/#{tweet.id}/create"
      link.click
      link = find('.unlike')
      expect(link[:href]).to include "/likes/#{tweet.id}/destroy"
      link.click
      link = find('.like')
      expect(link[:href]).to include "/likes/#{tweet.id}/create"
    end

    it "ツイート詳細ページからいいね登録/解除ができること", js: true do
      visit tweet_path(tweet)
      link = find('.like')
      expect(link[:href]).to include "/likes/#{tweet.id}/create"
      link.click
      link = find('.unlike')
      expect(link[:href]).to include "/likes/#{tweet.id}/destroy"
      link.click
      link = find('.like')
      expect(link[:href]).to include "/likes/#{tweet.id}/create"
    end

    it "ユーザー個別ページからいいね登録/解除ができること", js: true do
      visit user_path(user)
      link = find('.like')
      expect(link[:href]).to include "/likes/#{tweet.id}/create"
      link.click
      link = find('.unlike')
      expect(link[:href]).to include "/likes/#{tweet.id}/destroy"
      link.click
      link = find('.like')
      expect(link[:href]).to include "/likes/#{tweet.id}/create"
    end
  end
end
