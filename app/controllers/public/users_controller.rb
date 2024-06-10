class Public::UsersController < ApplicationController

  def mypage
    @user = current_user
    @posts = @user.posts
    @genre = params[:genre]
    @posts_shine = @posts.where(genre: 0)
    @posts_dark = @posts.where(genre: 1)
    @post = Post.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to users_mypage_path
  end

  private
  def user_params
    params.require(:user).permit(:header_image, :prfile_image, :name, :account_id, :introduction, :genre)
  end
end
