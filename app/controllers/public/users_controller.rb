class Public::UsersController < ApplicationController

  def mypage
    @user = current_user
    @posts = @user.posts
    @genre = params[:genre]
    @posts_shine = @posts.where(genre: 0)
    @posts_dark = @posts.where(genre: 1)
    @post = Post.new
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
    @posts_shine = @posts.where(genre: 0)
    @posts_dark = @posts.where(genre: 1)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to users_mypage_path
  end

  def hide
    @user = User.find(params[:id])
    @user.update(is_active: false)
    reset_session
    flash[:notice] = "退会処理が完了いたしました。またのご利用を心よりお待ちしております。"
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:header_image, :profile_image, :name, :account_id, :introduction, :genre)
  end

  def check_user_status
    user = User.find(params[:id])
    if user.is_deleted
      redirect_to root_path
    end
  end
end
