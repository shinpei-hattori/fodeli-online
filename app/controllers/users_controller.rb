class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @selected_status = params[:status]
    # debugger
    if @selected_status == "ツイート履歴"
      @tweets = Kaminari.paginate_array(@user.tweets).page(params[:page]).per(5)
    elsif @selected_status == "いいねしたツイート"
      @like_tweet = Kaminari.paginate_array(@user.likes.map(&:tweet)).page(params[:page]).per(5)
    elsif @selected_status.nil?
      @tweets = Kaminari.paginate_array(@user.tweets).page(params[:page]).per(5)
    end
    # 以下DM機能のコード
    # 自分と相手がチャットルームにエントリーしているか確認
    @current_user_entry = DmEntrie.where(user_id: current_user.id)
    @user_entry = DmEntrie.where(user_id: @user.id)
    unless @user.id == current_user.id
      if !@current_user_entry.nil? && !@user_entry.nil?
        @current_user_entry.each do |cu|
          @user_entry.each do |u|
            if cu.dm_room_id == u.dm_room_id
              @is_room = true
              @room_id = cu.dm_room_id
            end
          end
        end
      end
      unless @is_room
        @room = DmRoom.new
        @entry = DmEntrie.new
      end
    end
  end

  def index
    @users = User.page(params[:page]).per(30)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Fodeli Onlineへようこそ！"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params_update)
      flash[:success] = "プロフィールが更新されました！"
      redirect_to @user
    else
      flash[:danger] = @user.errors.full_messages
      redirect_to edit_user_path(@user)
    end
  end

  def destroy
    @user = User.find(params[:id])
    # 管理者ユーザーの場合
    if current_user.admin?
      @user.destroy
      flash[:success] = "ユーザーの削除に成功しました"
      redirect_to users_url
    # 管理者ユーザーではないが、自分のアカウントの場合
    elsif current_user?(@user)
      @user.destroy
      flash[:success] = "自分のアカウントを削除しました"
      redirect_to root_url
    else
      flash[:danger] = "他人のアカウントは削除できません"
      redirect_to root_url
    end
  end

  def following
    @title = "フォロー中"
    @user  = User.find(params[:id])
    @users = Kaminari.paginate_array(@user.following).page(params[:page])
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = Kaminari.paginate_array(@user.followers).page(params[:page])
    render 'show_follow'
  end

  def dmlists
    @user = current_user
    @entries = @user.dm_entry
    if @entries.present?
      @rooms = @entries.map(&:dm_room)
      @rooms = @rooms.sort { |x, y| x.updated_at <=> y.updated_at }.reverse
    end
    # debugger
  end

  private

    # ユーザー新規作成時に許可する属性
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # プロフィール編集時に許可する属性
    def user_params_update
      params.require(:user).permit(:name, :email, :introduction, :sex)
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      if !current_user?(@user)
        flash[:danger] = "このページへはアクセスできません"
        redirect_to(root_url)
      end
    end
end
