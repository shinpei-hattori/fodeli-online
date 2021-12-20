class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @tweet = Tweet.find(params[:tweet_id])
    @user = @tweet.user
    @comment = @tweet.comments.build(user_id: current_user.id, content: params[:comment][:content])
    if !@tweet.nil? && @comment.save
      # 通知を登録
      @tweet.create_notification_comment!(current_user,@comment.id)
      flash[:success] = "コメントを追加しました！"
    else
      flash[:danger] = @comment.errors.full_messages
    end
    redirect_to request.referrer || root_url
  end

  def destroy
    @comment = Comment.find(params[:id])
    @tweet = @comment.tweet
    if current_user.id == @comment.user_id
      @comment.destroy
      flash[:success] = "コメントを削除しました"
    end
    redirect_to tweet_url(@tweet)
  end
end
