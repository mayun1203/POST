class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "登録に成功しました。"
      redirect_to admin_user_path(@user)
    else
      flash[:danger] = "登録に失敗しました。"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:profile_image, :name, :account_id, :email, :phone_number, :is_active)
  end
end
