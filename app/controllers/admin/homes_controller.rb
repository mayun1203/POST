class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @users = User.all
    @posts = Post.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
  end
end
