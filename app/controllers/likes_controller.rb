class LikesController < ApplicationController
  before_action :logged_in_user
  def create
    @tweet = Tweet.find(params[:tweet_id])
    @user = @tweet.user
    current_user.like(@tweet)
    # いいねの通知作成
    @tweet.create_notification_like!(current_user)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end

  def destroy
    @tweet = Tweet.find(params[:tweet_id])
    current_user.likes.find_by(tweet_id: @tweet.id).destroy
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end
end
