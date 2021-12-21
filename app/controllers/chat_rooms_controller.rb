class ChatRoomsController < ApplicationController
  before_action :logged_in_user
  before_action :Authority, only: [:show, :destroy]

  def index
    @hokkaido = Prefecture.find_by(name: "北海道")
    @tohoku = Prefecture.where(name: ['青森県', '岩手県', '宮城県', '秋田県', '山形県', '福島県'])
    @kanto = Prefecture.where(name: ['茨城県', '栃木県', '群馬県', '埼玉県', '千葉県', '東京都', '神奈川県'])
    @tyubu = Prefecture.where(name: ['新潟県', '富山県', '石川県', '福井県', '山梨県', '長野県', '岐阜県', '静岡県', '愛知県'])
    @kinki = Prefecture.where(name: ['三重県', '滋賀県', '京都府', '大阪府', '兵庫県', '奈良県', '和歌山県'])
    @china = Prefecture.where(name: ['鳥取県', '島根県', '岡山県', '広島県', '山口県'])
    @shikoku = Prefecture.where(name: ['徳島県', '香川県', '愛媛県', '高知県'])
    @kyusyu = Prefecture.where(name: ['福岡県', '佐賀県', '長崎県', '熊本県', '大分県', '宮崎県', '鹿児島県', '沖縄県'])
  end

  def create
    company = Company.find_by(name: params[:company]).id
    city = Area.find_by(city: params[:city]).id
    if company && city
      chat = ChatRoom.find_by(company_id: company, area_id: city)
      if chat.present?
        if ChatUser.find_by(user: current_user, chat_room_id: chat.id).nil?
          ChatUser.create(user: current_user, chat_room_id: chat.id)
        end
        redirect_to chat_room_path(chat)
      else
        room = ChatRoom.create!(company_id: company, area_id: city)
        ChatUser.create(user: current_user, chat_room_id: room.id)
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
      @messages = @room.chat_posts
      # チャット日付作成
      post_dates = @messages.group_by{|post_date| post_date.created_at.to_date}
      @first_post_time = []
      post_dates.each do |pd|
        first_pd = pd.flatten[1]
        @first_post_time << first_pd.created_at
      end
      # ここまで
      @message = ChatPost.new
      @users = @room.chat_users
      @post = ChatPost.new

    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    # ルームの削除ではなく、チャットユーザーを削除するアクション
    room = ChatRoom.find(params[:id])
    chat_user = ChatUser.find_by(chat_room_id: params[:id], user_id: current_user.id)
    if chat_user.present?
      chat_user.destroy
      flash[:success] = "ルームを退出しました"
      if !request.referrer.nil? && request.referrer.include?(chat_room_path(room))
        redirect_to root_url
      else
        redirect_back(fallback_location: root_path)
      end
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def Authority
    check = ChatUser.find_by(chat_room_id: params[:id], user_id: current_user.id)
    unless check
      redirect_to root_url
      flash[:danger] = "権限がありません"
    end
  end
end
