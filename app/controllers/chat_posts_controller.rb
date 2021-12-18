class ChatPostsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:destroy]
  def create
    if ChatUser.find_by(user_id: current_user.id, chat_room_id: params[:chat_post][:chat_room_id]).present?
      @message = ChatPost.new(params.require(:chat_post).permit(:user_id, :message, :chat_room_id).merge(user_id: current_user.id))
      if @message.save
        @messages = @message.chat_room.chat_posts
        respond_to do |format|
          format.html { redirect_to chat_room_path(@message.chat_room) }
          format.js
        end
        # debugger
        # redirect_to chat_room_path(@message.chat_room)
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
