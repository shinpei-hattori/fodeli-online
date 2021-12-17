class DmMessagesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:destroy]
  def create
    # debugger
    if DmEntrie.find_by(user_id: current_user.id, dm_room_id: params[:dm_message][:dm_room_id]).present?
      @message = DmMessage.new(params.require(:dm_message).permit(:user_id, :message, :dm_room_id).merge(user_id: current_user.id))
      if @message.save
        @messages = @message.dm_room.dm_messages
        respond_to do |format|
          format.html { redirect_to dm_room_path(@message.dm_room) }
          format.js
        end
      else
        flash[:danger] = @message.errors.full_messages
        redirect_to dm_room_path(@message.dm_room)
      end
    else
      redirect_to root_url
    end
  end

  def destroy
    @room = @message.dm_room
    @messages = @room.dm_messages
    @message.destroy
    respond_to do |format|
      format.html { redirect_to dm_room_path(@room) }
      format.js
    end
  end

  private

  def correct_user
    @message = current_user.dm_messages.find_by(id: params[:id])
    redirect_to root_url if @message.nil?
  end
end
