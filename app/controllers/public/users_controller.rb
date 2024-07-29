class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, :only => [:mypage, :show, :destroy]
  before_action :ensure_guest_user, only: [:edit]

  def mypage
    @user = current_user
    @posts = @user.posts.order(created_at: :desc)
    @genre = params[:genre]
    @posts_shine = @posts.where(genre: 0)
    @posts_dark = @posts.where(genre: 1)
    @post = Post.new
    @liked_posts = Post.liked_posts(current_user)
    #通知を確認済みに更新
    current_user.passive_notifications.update_all(is_checked: true)
  end

  def show
    @user = User.find(params[:id])
    if @user == current_user
      return redirect_to users_mypage_path
    end
    @posts = @user.posts
    @posts_shine = @user.posts.where(genre: 0)
    @posts_dark = @user.posts.where(genre: 1)
  end

  def edit
    @user = User.find(params[:id])
    @genre = params[:genre]
    redirect_to users_mypage_path unless current_user.id == @user.id
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "登録に成功しました。"
      redirect_to users_mypage_path
    else
      flash[:danger] = "登録に失敗しました。"
      render :edit
    end
  end

  def liked_posts
    @liked_posts = Post.liked_posts(current_user)
  end

  def followings
    @user = User.find(params[:id])
    @users = @user.followings
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
  end

  def hide
    @user = User.find(params[:id])
    @user.update(is_active: false)
    reset_session
    flash[:success] = "退会処理が完了いたしました。またのご利用を心よりお待ちしております。"
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:profile_image, :name, :account_id, :email, :phone_number,:introduction, :genre)
  end

  def set_user
     @user = User.find_by(:id => params[:id])
  end

  def check_user_status
    user = User.find(params[:id])
    if user.is_deleted
      redirect_to root_path
    end
  end

  def ensure_guest_user
    if @user.guest_user?
      redirect_to users_mypage_path(current_user), notice: "ゲストユーザーはユーザー設定画面に遷移できません。"
    end
  end
end
