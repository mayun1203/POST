class Public::UsersController < ApplicationController
  before_action :set_user, :only => [:mypage, :show, :followings, :followers, :destroy]

  def mypage
    @user = current_user
    @posts = @user.posts
    @genre = params[:genre]
    @posts_shine = @posts.where(genre: 0)
    @posts_dark = @posts.where(genre: 1)
    @post = Post.new
    @liked_posts = Post.liked_posts(current_user)
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
    @users = @user.followings
  end

  def followers
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
end
