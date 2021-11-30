class TweetsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update, :destroy]

  def new
    @tweet = Tweet.new
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  def create
    @tweet = current_user.tweets.build(tweet_params)
    if @tweet.save
      flash[:success] = "ツイートを投稿しました！"
      redirect_to root_url
    else
      flash[:danger] = @tweet.errors.full_messages
      redirect_to root_url
    end
  end

  def edit
    @tweet = Tweet.find(params[:id])
  end

  def update
    @tweet = Tweet.find(params[:id])
    if @tweet.update_attributes(tweet_params)
      flash[:success] = "ツイートが更新されました！"
      redirect_to @tweet
    else
      flash[:danger] = @tweet.errors.full_messages
      redirect_to edit_tweet_path(@tweet)
    end
  end

  def destroy
    @tweet.destroy
    flash[:success] = "ツイートを削除しました！"
    if request.referer&.include?(edit_tweet_path(@tweet))
      redirect_to root_url
    elsif request.referer&.include?(tweet_path(@tweet))
      redirect_to root_url
    else
      redirect_to request.referrer || root_url
    end
  end

  private

    def tweet_params
      params.require(:tweet).permit(:content, { pictures: [] })
    end

    def correct_user
      @tweet = current_user.tweets.find_by(id: params[:id])
      if @tweet.nil?
        flash[:danger] = "ツイートを削除する権限がありません"
        redirect_to root_url
      end
    end
end
