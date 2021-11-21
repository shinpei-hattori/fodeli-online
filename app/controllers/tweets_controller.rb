class TweetsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,   only: :destroy

  def new
    @tweet = Dish.new
  end

  def create
    @tweet = current_user.tweets.build(tweet_params)
    if @tweet.save
      flash[:success] = "ツイートを投稿しました！"
      redirect_to root_url
    else
      @feed_items = Kaminari.paginate_array(current_user.feed).page(params[:page]).per(5)
      @feed_count = current_user.feed.count
      render 'static_pages/home'
    end
  end

  def destroy
    @tweet.destroy
    flash[:success] = "ツイートを削除しました！"
    redirect_to request.referrer || root_url
  end

  private

    def tweet_params
      params.require(:tweet).permit(:content)
    end

    def correct_user
      @tweet = current_user.tweets.find_by(id: params[:id])
      if @tweet.nil?
        flash[:danger] = "ツイートを削除する権限がありません"
        redirect_to root_url
      end
    end

end
