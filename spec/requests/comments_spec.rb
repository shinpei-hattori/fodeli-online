require 'rails_helper'

RSpec.describe "ツイートのコメント機能", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:third) { create(:user) }
  let!(:forth) { create(:user) }
  let!(:tweet) { create(:tweet,user: user) }
  let!(:comment) { create(:comment, user: user, tweet: tweet) }

  context "コメントの登録と通知の登録" do
    context "ログインしている場合" do
      before do
        login_for_request(user)
      end

      it "有効な内容のコメントが登録と、コメント通知登録ができること" do
        expect {
          post comments_path, params: { tweet_id: tweet.id,
                                        comment: { content: "最高です！" } }
        }.to change(tweet.comments, :count).by(1).and change(Notification, :count).by(1)
      end

      it "コメントしたユーザーが複数いる場合、投稿者と自分以外のコメントしたユーザー分通知が作成されること" do
        login_for_request(forth)
        create(:comment, user: other_user, tweet: tweet)
        create(:comment, user: third, tweet: tweet)
        expect {
          post comments_path, params: { tweet_id: tweet.id,
                                        comment: { content: "最高です！" } }
        }.to change(Notification, :count).by(3)
      end

      it "無効な内容のコメントが登録できないこと" do
        expect {
          post comments_path, params: { tweet_id: tweet.id,
                                        comment: { content: "" } }
        }.not_to change(tweet.comments, :count)
      end
    end

    context "ログインしていない場合" do
      it "コメントは登録できず、ログインページへリダイレクトすること" do
        expect {
          post comments_path, params: { tweet_id: tweet.id,
                                        comment: { content: "すごいですね！" } }
        }.not_to change(tweet.comments, :count)
        expect(response).to redirect_to login_path
      end
    end
  end

  context "コメントの削除" do
    context "ログインしている場合" do
      context "コメントを作成したユーザーである場合" do
        it "コメントの削除ができること" do
          login_for_request(user)
          expect {
            delete comment_path(comment)
          }.to change(tweet.comments, :count).by(-1)
        end
      end

      context "コメントを作成したユーザーでない場合" do
        it "コメントの削除はできないこと" do
          login_for_request(other_user)
            expect {
             delete comment_path(comment)
            }.not_to change(tweet.comments, :count)
        end
      end
    end

    context "ログインしていない場合" do
      it "コメントの削除はできず、ログインページへリダイレクトすること" do
        expect {
          delete comment_path(comment)
        }.not_to change(tweet.comments, :count)
      end
    end
  end
end
