class Admin::PostCommentsController < ApplicationController

  def index
    @post_comments = Comment.order(create_at: :desc).page(params[:page]).per(10)
    @users = User.all
  end

  def destroy
    @post_comment = Comment.find(params[:id])
    @post_comment.destroy
    redirect_to admin_post_comments_path
  end
end
