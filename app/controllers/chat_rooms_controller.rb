class ChatRoomsController < ApplicationController
  before_action :logged_in_user
  before_action :Authority, only: [:show]


  def index
    @pref = Prefecture.all
    @tohoku = @pref[2..7]
    @kanto = @pref[8..14]
    @tyubu = @pref[15..23]
    @kinki = @pref[24..30]
    @china = @pref[31..35]
    @shikoku = @pref[36..39]
    @kyusyu = @pref[40..48]
  end

  def create
    company = Company.find_by(name: params[:company]).id
    city = Area.find_by(city: params[:city]).id
    if company && city
      chat = ChatRoom.find_by(company_id: company,area_id: city)
      if chat.present?
        if ChatUser.find_by(user: current_user,chat_room_id: chat.id).nil?
          ChatUser.create(user: current_user,chat_room_id: chat.id)
        end
        redirect_to chat_room_path(chat)
      else
        room = ChatRoom.create!(company_id: company,area_id: city)
        ChatUser.create(user: current_user,chat_room_id: room.id)
        redirect_to chat_room_path(room.id)
      end
    else
      flash[:danger] = "値が不正です。"
      redirect_back(fallback_location: root_path)
    end
  end

  def show
    @room = ChatRoom.find(params[:id])
    @company = Company.find(@room.company_id)
    @area = Area.find(@room.area_id)
    if ChatUser.find_by(user_id: current_user.id, chat_room_id: @room.id).present?
      # @messages = @room.dm_messages
      # @message = DmMessage.new
      @users = @room.chat_users
      @post = ChatPost.new
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def Authority
    check = ChatUser.find_by(chat_room_id: params[:id], user_id: current_user.id)
    unless check
      redirect_to root_url
      flash[:danger] = "権限がありません"
    end
  end
end
