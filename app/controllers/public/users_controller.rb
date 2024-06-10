class Public::UsersController < ApplicationController

  def mypage
    #@user = User.find(params[:id])
  end

  def edit
    #@user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to users_mypage_path
  end

  private
  def user_params
    params.require(:user).permit(:header_image, :prfile_image, :name, :introduction)
  end
end
