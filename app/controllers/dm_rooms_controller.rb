class DmRoomsController < ApplicationController
  before_action :logged_in_user
  before_action :Authority, only: [:show]

  def index
    @chat_room = ChatRoom.new
  end

  def create
    @room = DmRoom.create
    @entry1 = DmEntrie.create(dm_room_id: @room.id, user_id: current_user.id)
    @entry2 = DmEntrie.create(dm_room_id: @room.id, user_id: params[:dm_room][:dm_entrie][:user_id])
    redirect_to "/dm_rooms/#{@room.id}"
  end

  def show
    @room = DmRoom.find(params[:id])
    if DmEntrie.where(user_id: current_user.id, dm_room_id: @room.id).present?
      @messages = @room.dm_messages
      # チャット日付作成
      post_dates = @messages.group_by { |post_date| post_date.created_at.to_date }
      @first_post_time = []
      post_dates.each do |pd|
        first_pd = pd.flatten[1]
        @first_post_time << first_pd.created_at
      end
      # ここまで
      @message = DmMessage.new
      @entries = @room.dm_entry
      @room.dm_entry.each do |u|
        if current_user?(u.user)
          @own = u.user
        else
          @user = u.user
        end
      end
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

    def Authority
      check = DmEntrie.find_by(dm_room_id: params[:id], user_id: current_user.id)
      unless check
        redirect_to root_url
        flash[:danger] = "権限がありません"
      end
    end
end
