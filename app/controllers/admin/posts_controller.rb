class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def show
    @post = Post.find(params[:id])

  end

  def destroy
    #byebug
    @post = Post.find(params[:id])
    @user = @post.user
    @post.destroy
    redirect_to admin_user_path(@user)
  end
end
