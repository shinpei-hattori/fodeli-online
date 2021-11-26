class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @feed_items = Kaminari.paginate_array(current_user.feed).page(params[:page]).per(5)
      @feed_count = current_user.feed.count
      @tweet = current_user.tweets.build
    end
  end

  def about
  end
end
