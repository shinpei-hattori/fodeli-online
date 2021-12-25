class DmMessagesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:destroy]
  def create
    if DmEntrie.find_by(user_id: current_user.id, dm_room_id: params[:dm_message][:dm_room_id]).present?
      @message = DmMessage.new(params.require(:dm_message).permit(:user_id, :message, :dm_room_id).merge(user_id: current_user.id))
      if @message.save
        # 通知作成
        @message.create_notification_dm_message!(current_user)
        @messages = @message.dm_room.dm_messages
        # チャット日付作成
        post_dates = @messages.group_by { |post_date| post_date.created_at.to_date }
        @first_post_time = []
        post_dates.each do |pd|
          first_pd = pd.flatten[1]
          @first_post_time << first_pd.created_at
        end
        # ここまで
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
    # チャット日付作成
    post_dates = @messages.group_by { |post_date| post_date.created_at.to_date }
    @first_post_time = []
    post_dates.each do |pd|
      first_pd = pd.flatten[1]
      @first_post_time << first_pd.created_at
    end
    # ここまで
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
