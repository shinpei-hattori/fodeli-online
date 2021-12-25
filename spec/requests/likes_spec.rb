require 'rails_helper'

RSpec.describe "ツイートのいいね登録機能", type: :request do
  let(:user) { create(:user) }
  let(:tweet) { create(:tweet) }

  context "いいね登録処理と通知登録" do
    context "ログインしていない場合" do
      it "いいね登録は実行できず、ログインページへリダイレクトすること" do
        expect {
          post "/likes/#{tweet.id}/create"
        }.not_to change(Like, :count)
        expect(response).to redirect_to login_path
      end

      it "いいね解除は実行できず、ログインページへリダイレクトすること" do
        expect {
          delete "/likes/#{tweet.id}/destroy"
        }.not_to change(Like, :count)
        expect(response).to redirect_to login_path
      end
    end

    context "ログインしている場合" do
      before do
        login_for_request(user)
      end

      it "ツイートのいいね登録と、いいね通知登録ができること" do
        expect {
          post "/likes/#{tweet.id}/create"
        }.to change(user.likes, :count).by(1).and change(Notification, :count).by(1)
      end

      it "Ajaxによるツイートのいいね登録と、いいね通知登録ができること" do
        expect {
          post "/likes/#{tweet.id}/create", xhr: true
        }.to change(user.likes, :count).by(1).and change(Notification, :count).by(1)
      end

      it "ツイートのいいねの解除ができること" do
        user.like(tweet)
        expect {
          delete "/likes/#{tweet.id}/destroy"
        }.to change(user.likes, :count).by(-1)
      end

      it "Ajaxによるツイートのいいね解除ができること" do
        user.like(tweet)
        expect {
          delete "/likes/#{tweet.id}/destroy", xhr: true
        }.to change(user.likes, :count).by(-1)
      end
    end
  end
end
