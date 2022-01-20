class TweetsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update, :destroy]

  def new
    @tweet = Tweet.new
  end

  def show
    @tweet = Tweet.find(params[:id])
    @like_count = @tweet.likes.count
    @comment = Comment.new
    @comments = Kaminari.paginate_array(@tweet.feed_comment(@tweet.id)).page(params[:page]).per(5)
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

  def search
    @feed_items = Kaminari.paginate_array(current_user.tweet_search(params[:keyword])).page(params[:page]).per(5)
    @feed_count = current_user.tweet_search(params[:keyword]).count
    @search = 'search'
    @tweet = current_user.tweets.build
    render 'static_pages/home'
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
