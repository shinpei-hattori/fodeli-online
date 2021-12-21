class ChatPostsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:destroy]
  def create
    if ChatUser.find_by(user_id: current_user.id, chat_room_id: params[:chat_post][:chat_room_id]).present?
      @message = ChatPost.new(params.require(:chat_post).permit(:user_id, :message, :chat_room_id).merge(user_id: current_user.id))
      if @message.save
        @messages = @message.chat_room.chat_posts
        # created_at = Mon, 20 Dec 2021 15:42:17 JST +09:00
        # created_at.to_date = Mon, 20 Dec 2021
        # チャット日付作成
        post_dates = @messages.group_by{|post_date| post_date.created_at.to_date}
        @first_post_time = []
        post_dates.each do |pd|
          first_pd = pd.flatten[1]
          @first_post_time << first_pd.created_at
        end
        # ここまで
        respond_to do |format|
          format.html { redirect_to chat_room_path(@message.chat_room) }
          format.js
        end
      else
        flash[:danger] = @message.errors.full_messages
        redirect_to chat_room_path(@message.chat_room)
      end
    else
      redirect_to root_url
    end
  end

  def destroy
    @room = @message.chat_room
    @messages = @room.chat_posts
    @message.destroy
    # チャット日付作成
    post_dates = @messages.group_by{|post_date| post_date.created_at.to_date}
    @first_post_time = []
    post_dates.each do |pd|
      first_pd = pd.flatten[1]
      @first_post_time << first_pd.created_at
    end
    # ここまで
    respond_to do |format|
      format.html { redirect_to chat_room_path(@room) }
      format.js
    end
  end

  private

  def correct_user
    @message = current_user.chat_posts.find_by(id: params[:id])
    redirect_to root_url if @message.nil?
  end
end
